			         EXPORT Ana_Program
Delay_suresi         EQU  0x109A95;8mhz/3(clock sinyali)=2.333.333=0x239A95
RCC                  EQU  0x40021000 ;RCC nin adresi
GPIOA_CRL	         EQU  0x40010800 ;Port c nin adresi
GPIOA_ODR	         EQU  0x4001080C	
RCC_APBENR           EQU  0x40021000	
ADC1_CR              EQU  0x40012408
RCC_APB2ENR          EQU  0x40021000	
USART2_BRR           EQU  0x40004408
SysTickVal           EQU  0x08000335
RCC_CR               EQU  0x40021000
RCC_CFGR             EQU  0x40021000
FLASH_ACR            EQU  0x40022000
Ram_adres            EQU  0x20000500
;........................................................
;PA8 -> tx
;PA0 -> Analog in

;..........................................................

				     AREA Bolum3, CODE, READONLY							   							   

;.......................Delays..........................
     ;6:         for(;time>0;time--) 
     ;7:         { 
Delay_fonksiyonu     B        forr
     ;8:          for(t=0;t<200;t++) 
     ;9:                 {} 
    ;10:         } 
sayy                 MOVS     r1,#0x02
ekle                 ADDS     r1,r1,#1
                     CMP      r1,#0xC8  ;0x7D0=2000 dec
                     BLT      ekle
                     SUBS     r0,r0,#1
     ;6:         for(;time>0;time--) 
     ;7:         { 
     ;8:          for(t=0;t<20;t++) 
     ;9:                 {} 
    ;10:         } 
forr                 CMP      r0,#0x00
                     BGT      sayy
					 
					 
                     BX       lr
   ;988: { 
;.......................Delays..........................


Ana_Program
;*****************************************************************************CLOCK CONFIGURATION 72MHZ				   
				     ;1014:     FLASH->ACR |= FLASH_ACR_PRFTBE; 
  ;1015:  
  ;1016:     /* Flash 2 wait state */ 
                   LDR      r0,=FLASH_ACR  
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x10
                   LDR      r1,=FLASH_ACR  
                   STR      r0,[r1,#0x00]
  ;1017:     FLASH->ACR &= (uint32_t)((uint32_t)~FLASH_ACR_LATENCY); 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x00]
                   BIC      r0,r0,#0x03
                   STR      r0,[r1,#0x00]
  ;1018:     FLASH->ACR |= (uint32_t)FLASH_ACR_LATENCY_2;     
  ;1019:  
  ;1020:   
  ;1021:     /* HCLK = SYSCLK */ 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x02
                   STR      r0,[r1,#0x00]
	     ;5:                         RCC->CR |= 0x00030000;//Pll ON 
     ;6:            // while(!(RCC->CR & 0x20000))//hse ON
                   LDR      r0,=RCC_CR
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x10000
                   LDR      r1,=RCC_CR
                   STR      r0,[r1,#0x00] 				   
  ;12:       RCC->CFGR |= 0x00000400;  //apb1 /2 DIVIDE 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x400                                              
                   STR      r0,[r1,#0x04]		
  ;1054:     RCC->CFGR &= (uint32_t)((uint32_t)~(RCC_CFGR_PLLSRC | RCC_CFGR_PLLXTPRE | 
  ;1055:                                         RCC_CFGR_PLLMULL)); 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   BIC      r0,r0,#0x3F0000
                   STR      r0,[r1,#0x04]				   		   
    ;10:       RCC->CFGR |= 0x001C0000;  //PLLMUL X9 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x1C0000
                   STR      r0,[r1,#0x04]
    ;13:       RCC->CFGR |= 0x00000002; //PLL   System clock
    ;14:                          
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x02
                   STR      r0,[r1,#0x04]
	;10:       RCC->CFGR |= 0x001C0000;  //PLL entry clock source
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x10000
                   STR      r0,[r1,#0x04]			   
				   ;  1060:     RCC->CR |= RCC_CR_PLLON; 
 ; 1061:  
 ; 1062:     /* Wait till PLL is ready */ PLLON: PLL enable
                   MOV      r0,r1
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x1000000
                   STR      r0,[r1,#0x00]
	;11:       RCC->CFGR |= 0x00000080;  //ahb prescaler 
       ;            MOV      r0,r1
      ;             LDR      r0,[r0,#0x04]
      ;             ORR      r0,r0,#0x90
     ;              STR      r0,[r1,#0x04]
;*****************************************************************************CLOCK CONFIGURATION 72MHZ	

    ;25:         RCC->APB2ENR = 0x4; /// GPIOA CLOCK 
                     LDR      r0,=RCC_APB2ENR   ; Cutput Open-drain ////////////////ADC setup      
                     MOVS     r1,#0x04
                     STR      r1,[r0,#0x18]
    ;26:         GPIOA->CRL &= ~0xF00;  /// PA2 OUT 
                     LDR      r1,=GPIOA_CRL ; 
                     LDR      r2,[r1,#0x00]
                     BIC      r2,r2,#0xF00
                     STR      r2,[r1,#0x00]
    ;27:         GPIOA->CRL |= (3<<8)|(2<<10);  /// PA2  output Open-drain 
    ;28: //////////////////////////////////////////////////////////////////////////////////ADC setup      
    ;29:         /*      RCC->AHBENR = 0x4;//  
    ;30:           GPIOA->CRL = 0xFF0FFFFF; /// A3 pin reset 
    ;31:           RCC->APB2ENR = 0x201; 
    ;32:                 ADC1->SQR3= 5;    */         
                     LDR      r2,[r1,#0x00]
                     ORR      r2,r2,#0xB00
                     STR      r2,[r1,#0x00]
    ;33:           RCC->APB2ENR = 0x201;          //ADC1 clock on 
                     MOVW     r1,#0x201
                     STR      r1,[r0,#0x18]
                     LDR      r1,=ADC1_CR   
    ;34:     ADC1->CR2 = 0x3; //adc continuous 
                     MOVS     r2,#0x03
                     STR      r2,[r1,#0x00]
    ;35:     ADC1->CR2 |= 0x4;// calibration      
                     LDR      r2,[r1,#0x00]
                     ORR      r2,r2,#0x04
                     STR      r2,[r1,#0x00]
    ;36:     ADC1->CR2 |=1; //adc on      
    ;37: //////////////////////////////////////////////////////////////////////////////////ADC setup      
    ;38:         //-----------Init UART ------------/// 
    ;39:         // Enable the Alternate Function for PINs 
                     LDR      r2,[r1,#0x00]
                     ORR      r2,r2,#0x01
                     STR      r2,[r1,#0x00]
    ;40:         RCC->APB2ENR |= 1; 
    ;41:         // Enable UART2 
                     LDR      r1,[r0,#0x18]
                     ORR      r1,r1,#0x01
                     STR      r1,[r0,#0x18]
    ;42:         RCC->APB1ENR |=0x20000; 
    ;43:         // Setup the baude rate for 9600 bps 
                     LDR      r1,[r0,#0x1C]
                     ORR      r1,r1,#0x20000
                     STR      r1,[r0,#0x1C]
                     LDR      r1,=USART2_BRR  
    ;44:         USART2->BRR = 0xEA6; //3750-->3750*9600=36mhz 
    ;45:         // Enable Uart Transmit 
                     MOVW     r0,#0xEA6;0x342    834*9600=8mhz  
                     STRH     r0,[r1,#0x00]
    ;46:         USART2->CR1 |= 8; 
    ;47:         // Enable Uart Recive 
    ;48:         //USART2->CR1 |= 4; 
    ;49:         // Enable Uart 
                     ADDS     r0,r1,#4
                     LDRH     r1,[r0,#0x00]
                     ORR      r1,r1,#0x08
                     STRH     r1,[r0,#0x00]
    ;50:         USART2->CR1 |= 0x2000; 
    ;51:         while(1) 
    ;52:         { 
    ;53:     Delays(10);   
                     LDRH     r1,[r0,#0x00]
                     ORR      r1,r1,#0x2000
                     STRH     r1,[r0,#0x00]
    ;54:                 while((USART2->SR & 0x40) == 0x80) 
    ;55:                 {}; 
                     LDR      r5,=USART2_BRR
    ;56:                 USART2->DR = (ADC1->DR)/16;//8 bit 
                     LDR      r3,=ADC1_CR
                     SUBS     r5,r5,#0x08
                     ADDS     r3,r3,#0x44
                     ADDS     r4,r5,#4

while                

    ;53:     Delays(10);   
                     MOVS     r0,#0xa0
                     BL       Delay_fonksiyonu 
    ;54:                 while((USART2->SR & 0x40) == 0x80) 
                     LDRH     r0,[r5,#0x00]
                     LDR      r0,[r3,#0x00]
                     LSRS     r0,r0,#4
                     STRH     r0,[r4,#0x00]
                    
                     B        while	


					 					
                     ALIGN
							   
				     END
