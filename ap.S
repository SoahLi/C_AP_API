/* configure_ap.S */
    .text
    .global configure_ap
    .type   configure_ap, @function

configure_ap:
    /* incoming per RISC-V calling convention:
       a0 = index, a1 = bool_active, a2 = bool_oneshot,
       a3 = target_addr, a4 = trigger_addr */

    csrw    iapselect, a0      /* select AP slot */
    csrw    iapctrl, a1        /* bool_active -> iapctrl */
    csrrw   zero, iaptar, a3   /* target_addr -> iaptar */
    csrrw   zero, iaptrig, a4  /* trigger_addr -> iaptrig */
    csrrsi  zero, iapctrl, 1   /* set enable bit */
    csrrs   zero, iapstatus, a2 /* bool_oneshot -> iapstatus (set bits) */

    ret
    .size   configure_ap, . - configure_ap


ap_set_active:
    /* a0 = index, a1 = active (0 to deactivate) */
    csrw    iapselect, a0
    csrw    iapctrl, a1
    ret
    .size   ap_set_active, . - ap_set_active


