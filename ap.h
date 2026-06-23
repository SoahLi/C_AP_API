#include <stdint.h>

#define AP_MAX_ENTRIES 64
#define AP_DISABLE 0x10
#define AP_ONESHOT 0x01
#define APRET() __asm__ __volatile__ ("apret x0, 0" :: : "cc")

int ap_reg(uintptr_t ap_addr, void(*ap_handler) (uintptr_t), uint8_t ap_flags);
void ap_ureg(uintptr_t ap_addr, void(*ap_handler)(uintptr_t));
int ap_sret(uintptr_t r_addr);

