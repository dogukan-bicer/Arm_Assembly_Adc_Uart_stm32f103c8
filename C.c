#include "stm32f10x.h"                  
#include "math.h"
/*
kurulum


PA2 -> 10k ntc
3.3v -> 10k ntc
Gnd-> 10k res

*/
int aa;
void Delays(int time) /// Random delay function
{
	int t;
	for(;time>0;time--)
	{
	 for(t=0;t<2000;t++)
		{}
	}
}

int main(void)
{
	RCC->APB2ENR = 0x4; /// GPIOA CLOCK
	GPIOA->CRL &= ~0xF00;  /// PA2 OUT
	GPIOA->CRL |= (3<<8)|(2<<10);  /// PA2  output Open-drain
//////////////////////////////////////////////////////////////////////////////////ADC setup	
	/*	RCC->AHBENR = 0x4;// 
	  GPIOA->CRL = 0xFF0FFFFF; /// A3 pin reset
	  RCC->APB2ENR = 0x201;
		ADC1->SQR3= 5;		*/	
	  RCC->APB2ENR = 0x201;	 	//ADC1 clock on
    ADC1->CR2 = 0x3; //adc continuous
    ADC1->CR2 |= 0x4;// calibration	
    ADC1->CR2 |=1; //adc on	
//////////////////////////////////////////////////////////////////////////////////ADC setup	
	//-----------Init UART ------------///
	// Enable the Alternate Function for PINs
	RCC->APB2ENR |= 1;
	// Enable UART2
	RCC->APB1ENR |=0x20000;
	// Setup the baude rate for 9600 bps
	USART2->BRR = 0xEA6; //3750-->3750*9600=36mhz
	// Enable Uart Transmit
	USART2->CR1 |= 8;
	// Enable Uart Recive
	//USART2->CR1 |= 4;
	// Enable Uart
	USART2->CR1 |= 0x2000;
	while(1)
	{
    Delays(10);		
		while((USART2->SR & 0x40) == 0x80)
		{};
		USART2->DR = (ADC1->DR)/16;//8 bit 1d4c
   }
}
/*
		lo_byte = deger & 0xFF;
    hi_byte = deger >> 8;
*/
