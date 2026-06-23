#include <stdint.h>
#include <stdio.h>
#include <errno.h>
#include "ap.h"



void my_fn_handler(uintptr_t addr) {
  uintptr_t new_addr = 0xdeadbeef; 
  printf("Handler called for address: 0x%lx\n", addr);
  ap_sret(new_addr);
  APRET();
}

int main() {
  uintptr_t instr_addr = 0x12345678; // Example instruction address
  uint8_t flags = AP_ONESHOT; //enable the AP_ONESHOT flag
  if(ap_reg(instr_addr, my_fn_handler, flags) == -1) {
    switch (errno) {
      case EINVAL:
        printf("Invalid arguments provided to ap_reg.\n");
        break;
      case ENOMEM:
        printf("No more AP entries available.\n");
        break;
      default:
        printf("An unknown error occurred: %d\n", errno);
    }
  }

  ap_ureg(instr_addr, my_fn_handler); 
  return 0;
}
