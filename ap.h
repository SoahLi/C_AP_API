#include <stdint.h>

// This will realistically be 4
#define AP_MAX_ENTRIES 64
#define AP_DISABLE 0x10
#define AP_ONESHOT 0x01


typedef struct {
 // might want to store the user-provided address and the trampoline address
 uintptr_t        addr;
 void           (*handler)(uint8_t);
} ap_entry_t;

typedef struct {
  uint8_t is_oneshot;
  uint8_t is_active;
} ap_flags_t;

//extern ap_entry_t ap_table[];

extern uint64_t free_mask;

//either use a hash map, or just do linear search on the ap_table. Probably linear search since the number of entries is so small
//extern unordered_map<pair<uintptr_t, void(*)(uint8_t)>, uint8_t> ap_index;

int ap_reg(uintptr_t ap_addr, void(*ap_handler) (uint8_t), uint8_t ap_flags);
int ap_ureg(uintptr_t ap_addr, void(*ap_handler)(uint8_t));
int ap_sret(uintptr_t r_addr);
