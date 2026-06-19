#include "ap.h"
#include <errno.h>

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
int find_ap_idx(uintptr_t ap_addr, void(*ap_handler)(uint8_t));
int alloc_empty_slot();
int alloc_empty_slot();
int alloc_slot();
void dealloc_slot(int index);
ap_flags_t parse_ap_flags(uint8_t ap_flags);
void configure_ap(int index, uint8_t bool_active, uint8_t bool_oneshot,void *target_addr, void *trigger_addr);
void ap_set_active(int index, uint8_t active);

int ap_reg(uintptr_t ap_addr, void(*ap_handler) (uint8_t), uint8_t ap_flags) {
  int idx = find_ap_idx(ap_addr, ap_handler);
  if (idx != -1 && (idx = alloc_empty_slot()) != -1) {
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
      dealloc_slot(i);
      ap_set_active(i, 0);
    }
  }
}


static inline int* extract_ap_flags(uint8_t ap_flags) {
    static int flags[2] = {0, 0};
    // Extract the second to rightmost bit (bit 1)
    flags[0] = (ap_flags >> 1) & 0x1;
    // Extract the rightmost bit (bit 0)
    flags[1] = ap_flags & 0x1;
    return flags;
}

int find_ap_idx(uintptr_t ap_addr, void(*ap_handler)(uint8_t)) {
    for (int i = 0; i < AP_MAX_ENTRIES; i++) {
        if (ap_table[i].addr == ap_addr && ap_table[i].handler == ap_handler) {
          alloc_slot(i);
          return i;
        }
    }
    return -1;
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
