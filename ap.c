#include "ap.h"
#include <errno.h>
#include <stdatomic.h>
#include <stddef.h>

typedef struct {
 // might want to store the user-provided address and the trampoline address
  uintptr_t addr;
  void (*handler)(uint8_t);
} ap_entry_t;

typedef struct {
  uint8_t is_oneshot;
  uint8_t is_active;
} ap_flags_t;

ap_entry_t ap_table[AP_MAX_ENTRIES];
uint64_t free_mask = ~0ULL; //1 means free, 0 means used
int acquire_ap_idx(uintptr_t ap_addr, void(*ap_handler)(uint8_t));
int alloc_slot();
void dealloc_slot(int index);
ap_flags_t parse_ap_flags(uint8_t ap_flags);
void configure_ap(int index, uint8_t bool_active, uint8_t bool_oneshot,void *target_addr, void *trigger_addr);
void ap_set_active(int index, uint8_t active);

int ap_reg(uintptr_t ap_addr, void(*ap_handler) (uint8_t), uint8_t ap_flags) {
  if (ap_handler == NULL || ap_addr == 0) {
    errno = EINVAL; 
    return -1;
  }

  int idx = acquire_ap_idx(ap_addr, ap_handler);
  if (idx == -1) {
    errno = ENOMEM; 
    return -1;
  }

  ap_flags_t flags = parse_ap_flags(ap_flags);
  if(flags.is_active >1 || flags.is_oneshot > 1) {
    errno = EINVAL;
    return -1;
  }

  configure_ap(idx, flags.is_active, flags.is_oneshot, (void*)ap_addr, (void*)ap_handler);
  return 0;
}

void ap_ureg(uintptr_t ap_addr, void(*ap_handler)(uint8_t)) {
  for (int i = 0; i < AP_MAX_ENTRIES; i++) {
    if (ap_table[i].addr == ap_addr && ap_table[i].handler == ap_handler) {
      ap_table[i].addr = 0;
      ap_table[i].handler = NULL;
      dealloc_slot(i);
      ap_set_active(i, 0);
      break;
    }
  }
}


int acquire_ap_idx(uintptr_t ap_addr, void(*ap_handler)(uint8_t)) {
    for (int i = 0; i < AP_MAX_ENTRIES; i++) {
        if (ap_table[i].addr == ap_addr && ap_table[i].handler == ap_handler) {
          return i;
        }
    }

    //this key does not exist, so attempt to allocate a new slot
    if(free_mask == 0) {
      return -1; //no more free slots
    }
    else {
      int idx = alloc_slot();
      ap_table[idx].addr = ap_addr;
      ap_table[idx].handler = ap_handler;
      return idx;
    }

}

int alloc_slot() {
    int slot = __builtin_ctzll(free_mask);  // single instruction
    free_mask &= ~(1ULL << slot);
    return slot;
}

void dealloc_slot(int index) {
  free_mask |= (1ULL << index);
}

ap_flags_t parse_ap_flags(uint8_t ap_flags) {
    ap_flags_t flags;
    flags.is_oneshot = ap_flags & AP_ONESHOT;
    flags.is_active = !(ap_flags & AP_DISABLE);
    return flags;
}
