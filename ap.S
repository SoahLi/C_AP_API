/* configure_ap.S */
    .text

    .equ    APCTRL_ACTIVE_MASK, 0b10
    .equ    APCTRL_RW_MASK,     0b11

    .global configure_ap
    .type   configure_ap, @function
configure_ap:
    /* incoming per RISC-V calling convention:
       a0 = index, a1 = bool_active, a2 = bool_oneshot,
       a3 = target_addr, a4 = trigger_addr */

    csrw    iapselect, a0       /* select AP slot */
    csrrw   zero, iaptar, a3    /* target_addr  -> iaptar */
    csrrw   zero, iaptrig, a4   /* trigger_addr -> iaptrig */

    slli    t0, a1, 1  /* move the value of the active param into first position*/
    or      t0, t0, a2 /* move the value of the oneshot param into zeroth position*/
    csrrci  zero, iapctrl, APCTRL_RW_MASK  /* clear clear the first and zeroth positions */
    csrrs   zero, iapctrl, t0               /* set the requested bits */

    ret
    .size   configure_ap, . - configure_ap


    .global ap_set_active
    .type   ap_set_active, @function

ap_set_active:
    /* a0 = index, a1 = active (0 to deactivate) */
    csrw    iapselect, a0

    andi    t0, a1, 1
    beqz    t0, 1f
    csrrsi  zero, iapctrl, APCTRL_ACTIVE_MASK   /* set active bit only */
    j       2f
1:
    csrrci  zero, iapctrl, APCTRL_ACTIVE_MASK   /* clear active bit only */
2:
    ret
    .size   ap_set_active, . - ap_set_active


    .global ap_sret 
    .type   ap_sret, @function
ap_sret:
    /* a0 = index, a1 = r_addr*/

    /*
    csrw    iapselect, a0
    csrw    APEPC, a1
    ret
    .size   ap_set_return_addr, . - ap_set_return_addr
    */

    csrw    APEPC, a0
    ret
    .size   ap_sret, . - ap_sret

