#include "ap.h"

ap_entry_t ap_table[AP_MAX_ENTRIES];
uint64_t free_mask = ~0ULL; //1 means free, 0 means used
static inline void configure_ap(int index, int privilege_active, void *target_addr, void *trigger_addr);
int find_ap_idx(uintptr_t ap_addr, void(*ap_handler)(uint8_t));
int alloc_empty_slot();
int alloc_empty_slot();

int ap_reg(uintptr_t ap_addr, void(*ap_handler) (uint8_t), uint8_t ap_flags) {
  int idx = find_ap_idx(ap_addr, ap_handler);
  if (idx != -1 && (idx = alloc_empty_slot()) != -1) {
    //produce error code
    return -1;
  }

  //verify that this is a valid instruction address
  //TODO
  //on error, produce valid error code

  //verify that this is a valid function pointer 
  //TODO
  //on error, produce valid error code

  //create the trampoline...

  
  configure_ap(idx, ap_flags);
  return 0;
}
 //int ap_ureg(uintptr_t ap_addr, void(*ap_handler)(uint8_t));
 //int ap_sret(uintptr_t r_addr);


static inline int* extract_ap_flags(uint8_t ap_flags) {
    static int flags[2] = {0, 0};
    // Extract the second to rightmost bit (bit 1)
    flags[0] = (ap_flags >> 1) & 0x1;
    // Extract the rightmost bit (bit 0)
    flags[1] = ap_flags & 0x1;
    return flags;
}

static inline void configure_ap(int index, int privilege_active,
                                  void *target_addr, void *trigger_addr)
{
    unsigned long scratch;

    __asm__ volatile (
        "csrw  iapselect, %[idx]     \n\t"
        "li    %[tmp], %[priv_act]   \n\t"
        "csrw  iapctrl, %[tmp]       \n\t"
        "la    %[tmp], %[tgt]        \n\t"
        "csrrw zero, iaptar, %[tmp]  \n\t"
        "la    %[tmp], %[trig]       \n\t"
        "csrrw zero, iaptrig, %[tmp] \n\t"
        "csrrsi zero, iapctrl, 1     \n\t"
        : [tmp]      "=r" (scratch)
        : [idx]       "r" (index),
          [priv_act]  "i" (privilege_active),
          [tgt]       "i" (target_addr),
          [trig]      "i" (trigger_addr)
    );
}

int find_ap_idx(uintptr_t ap_addr, void(*ap_handler)(uint8_t)) {
    for (int i = 0; i < AP_MAX_ENTRIES; i++) {
        if (ap_table[i].addr == ap_addr && ap_table[i].handler == ap_handler) {
            return i;
        }
    }
    return -1;
}

int alloc_empty_slot() {
    int slot = __builtin_ctzll(free_mask);  // single instruction
    free_mask &= ~(1ULL << slot);
    return slot;
}

void free_slot(int slot) {
    free_mask |= (1ULL << slot);
}

