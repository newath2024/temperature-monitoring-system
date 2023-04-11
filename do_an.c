/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 6/7/2022
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16.h>
#include <delay.h>
#include <string.h>
#include <stdio.h>
// I2C Bus functions
#include <i2c.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

// Alphanumeric LCD functions
#include <alcd.h>

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index=0,tx_rd_index=0;
#else
unsigned int tx_wr_index=0,tx_rd_index=0;
#endif

#if TX_BUFFER_SIZE < 256
unsigned char tx_counter=0;
#else
unsigned int tx_counter=0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
//khai bao bien
#include <stdio.h>
#define den_bao PORTA.7  
#define nut_phai PINA.0 
#define nut_trai PINA.1 
#define nut_giam PINA.2 
#define nut_tang PINA.3 
#define data_len hc05[1]
#define ma_lenh hc05[2]
#define checksum (hc05[ki_tu-2]*256 + hc05[ki_tu-1])
#define ki_tu_batdau '@'
#define on_tb 1
#define off_tb 0
#define trang_thai_tb 2
#define data_nhietdo 3 
#define tb1 PORTD.4
#define tb2 PORTD.5
#define tb3 PORTD.6
#define tb4 PORTD.7
#define trang_thai1 PIND.4
#define trang_thai2 PIND.5
#define trang_thai3 PIND.6
#define trang_thai4 PIND.7
#define on_all 0xFF
#define off_all 0x00

           // cau truc khung truyen 1 goi du lieu
           //ky tu bat dau (1 byte) + data len (1 byte) + ma lenh(1 byte) + data(n byte) + checksum(2 byte) 
           //vi du:          @                  05                00             01 02               0x00 0x05  
           // ma lenh: 00:off thiet bi/ 01:on / 02:lay trang thai thiet bi / 03: lay du lieu nhiet do 
           // trong do "data_len" la do dai cua goi du lieu duoc tinh tu "vi tri sau no" den het
           // checksum duoc tinh tu "data_len" cho toi "data"
int nhiet_do;

unsigned int ck;
unsigned char hc05[20],ki_tu,so_tb;
unsigned char vi_tri[6]={5,6,8,9,11,12};
unsigned char vi_tri_cai_dat,m;
unsigned int test[6];
unsigned char gio_cd, phut_cd, giay_cd,thu_cd, ngay_cd, thang_cd, nam_cd;
unsigned char gio, phut, giay, thu, ngay, thang, nam;
unsigned char chuoi1[6], chuoi2[6], chuoi3[6],chuoi4[6], chuoi5[6], chuoi6[6], chuoi[20];
unsigned char da_nhan_trai, da_nhan_phai, da_nhan_tang, da_nhan_giam;
void giaotiep_hc05(){
     // cau truc khung truyen 1 goi du lieu
           //ky tu bat dau (1 byte) + data len (1 byte) + ma lenh(1 byte) + data(n byte) + checksum(2 byte) 
           //vi du:          @                  05                00             01 02              0x00 0x05  
           // ma lenh: 00:off thiet bi/ 01:on / 02:lay trang thai thiet bi / 03: lay du lieu nhiet do 
           // trong do "data_len" la do dai cua goi du lieu duoc tinh tu "vi tri sau no" den het
           // checksum duoc tinh tu "data_len" cho toi "data"
       
        if(rx_counter>0)                       //  03                   03        00 06
        {    
            
            hc05[ki_tu]=getchar(); 
            if(hc05[ki_tu]==ki_tu_batdau){ 
                  hc05[0]=ki_tu_batdau;
                ki_tu=0;
                ck=0;
            }                                                                                    
            ki_tu++;
            if(ki_tu>1 && ki_tu<=data_len )  // i<data len       
            { 
                 ck=ck+hc05[ki_tu-1];
                 
            }
             
        } 
                                                              
         //kiem tra nhan du va dung goi du lieu   
        
         if(ki_tu==data_len+ 2  ) // 2: 2 byte bom gom "ky tu bat dau" va ky tu tu "data_len"        
                      // 1: la do sau khi nhan du lieu thi i++
         {      
                                                 
            if(hc05[0]==ki_tu_batdau && ck==checksum){    //nhan dung goi' du lieu  
                if(ma_lenh == on_tb){ 
                     for(so_tb=3;so_tb<data_len;so_tb++){  
                         if( hc05[so_tb] == 1){
                            tb1=1;                   
                         }
                          if( hc05[so_tb] == 2){
                            tb2=1;                   
                         }
                          if( hc05[so_tb] == 3){
                            tb3=1;                   
                         }
                          if( hc05[so_tb] == 4){
                            tb4=1;                   
                         }
                          if( hc05[so_tb] == 0xFF){
                            tb1=tb2=tb3=tb4=1;           
                         }
                     }
                    putchar(ki_tu_batdau); 
                    putchar(7);    
                    putchar(ma_lenh);
                    putchar(trang_thai1); 
                    putchar(trang_thai2);
                    putchar(trang_thai3);
                    putchar(trang_thai4);  
                    ck=7+ma_lenh+trang_thai1+trang_thai2+trang_thai3+trang_thai4; 
                    putchar(0);
                    putchar(ck);                  
                } 
                else if(ma_lenh == off_tb){ 
                     for(so_tb=3;so_tb<data_len;so_tb++){  
                         if( hc05[so_tb] == 0){
                                tb1=tb2=tb3=tb4=0;                   
                         } 
                         if( hc05[so_tb] == 1){
                            tb1=0;                   
                         }
                          if( hc05[so_tb] == 2){
                            tb2=0;                   
                         }
                          if( hc05[so_tb] == 3){
                            tb3=0;                   
                         }
                          if( hc05[so_tb] == 4){
                            tb4=0;                   
                         }

                     }
                    putchar(ki_tu_batdau); 
                    putchar(7);    // datalen 07 
                    putchar(ma_lenh);
                    putchar(trang_thai1); 
                    putchar(trang_thai2);
                    putchar(trang_thai3);
                    putchar(trang_thai4);  
                    ck=7+ma_lenh+trang_thai1+trang_thai2+trang_thai3+trang_thai4; 
                    putchar(0);
                    putchar(ck);                  
                }
                else if(ma_lenh ==trang_thai_tb){
                    putchar(ki_tu_batdau); 
                    putchar(7);    // datalen 07 
                    putchar(ma_lenh);
                    putchar(trang_thai1); 
                    putchar(trang_thai2);
                    putchar(trang_thai3);
                    putchar(trang_thai4);  
                    ck=7+ma_lenh+trang_thai1+trang_thai2+trang_thai3+trang_thai4; 
                    putchar(0);
                    putchar(ck);
                }
                else if(ma_lenh==data_nhietdo){
                    
                    putchar(ki_tu_batdau); 
                    putchar(4);    // datalen   
                    putchar(ma_lenh);
                    putchar(nhiet_do);
                     
                     
                    ck=4+ma_lenh+nhiet_do; 
                    putchar(0);
                    putchar(ck);
                }  
                
            }                                                               
            ck=0;                                                            
            ki_tu=0;                                                     
         }  
}
void hien_thi_chuoi(unsigned char data1, unsigned char data2, unsigned char data3,unsigned char ngay_gio,unsigned char cot, unsigned char hang);
void hieuchinh_ngaygio(){
    //kiem tra hieu chinh gio_cd
    if(gio_cd>100){  // do kieu du lieu khong dau unsigned char 0-1=255, chon so 100 la so dep
        gio_cd=23;
    }
    else if(gio_cd>23){
        gio_cd=0;
    }
    // kiem tra hieu chinh phut_cd
    if(phut_cd>100){  // do kieu du lieu khong dau unsigned char 0-1=255, chon so 100 la so dep
        phut_cd=59;
    }
    else if(phut_cd>59){
        phut_cd=0;
    } 
    // kiem tra hieu chinh giay_cd
    if(giay_cd>100){  // do kieu du lieu khong dau unsigned char 0-1=255, chon so 100 la so dep
        giay_cd=59;
    }
    else if(giay_cd>59){
        giay_cd=0;
    }
    // kiem tra hieu chinh ngay_cd 
    if(ngay_cd==0 || ngay_cd>100){
        if(thang_cd==1 || thang_cd==3 || thang_cd==5 || thang_cd==7 || thang_cd==8 || thang_cd==10 || thang_cd==12 ){
            ngay_cd=31;
        } 
        else if(thang_cd==4 || thang_cd==6 || thang_cd==9 || thang_cd==11){
            ngay_cd=30;
        }
        else{
            if(nam_cd%4 ==0){
                ngay_cd=29;
            }
            else{
                ngay_cd=28;
            }
        }
    }    
    
    //hieu chinh thang
    if(thang_cd>12 && thang_cd<100){
        thang_cd=1;    
    }
    else if(thang_cd >100 || thang_cd ==0){
        thang_cd=12;
    }  
    //sau khi hieu chinh thang thi hieu chinh lai ngay
    if(thang_cd==1 || thang_cd==3 || thang_cd==5 || thang_cd==7 || thang_cd==8 || thang_cd==10 || thang_cd==12 ){
        if(ngay_cd>31){
            ngay_cd=1;
        }    
    } 
    else if(thang_cd==4 || thang_cd==6 || thang_cd==9 || thang_cd==11){
        if(ngay_cd>30){
            ngay_cd=1;
        }
    }
    else{
        if(nam_cd%4 ==0){
            if(ngay_cd>29){
                ngay_cd=1;
            }
        }
        else{
            if(ngay_cd>28){
                ngay_cd=1;
            }
        }
    }
    //hieu chinh nam 
    if(nam_cd>150){
        nam_cd=99;
    }
    else if(nam_cd>99){  
        nam_cd=0;
    }
    
     
     
}
void xu_ly_nut(){
    unsigned char che_do, thu[6];
    int hang=0;  
    unsigned char dem=0; 
    int check;
    //bat con tro nhap nhay
    if(nut_tang ==0 && nut_giam== 0 && nut_trai==1 && nut_phai ==1){
        che_do=1; 
        while(che_do){  
            giaotiep_hc05();
            if(nut_giam==0 && nut_tang==1 && nut_trai==1 && nut_phai ==1 && da_nhan_giam ==0){
                da_nhan_giam=1;
                if(che_do==2){
                    che_do--;
                }
                else if(che_do==1){
                    che_do=2;
                }
            }
            if(nut_giam==1){
                da_nhan_giam=0;
            }
            if(nut_giam==1 && nut_tang==0 && nut_trai==1 && nut_phai ==1 && da_nhan_tang ==0){
                da_nhan_tang=1;
                if(che_do==1){
                    che_do++;
                }
                else if(che_do==2){
                    che_do=1;
                }
            }
            if(nut_tang==1){
                da_nhan_tang=0;
            }
            switch(che_do){
                case 1:
                lcd_gotoxy(0,0);
                lcd_puts("=>    CAI DAT GIO   "); 
                lcd_gotoxy(0,1);
                lcd_puts("      CAI DAT NGAY  ");
                break;
                case 2:   
                lcd_gotoxy(0,0);
                lcd_puts("      CAI DAT GIO   "); 
                lcd_gotoxy(0,1);
                lcd_puts("=>    CAI DAT NGAY  ");
                break;
            }
            // thoat che do cai dat
            if(nut_tang ==1 && nut_giam== 1 && nut_trai==0 && nut_phai ==0){
                che_do=0;
            }
            //vao cai dat theo che_do da lua chon
            if(nut_tang ==0 && nut_giam== 1 && nut_trai==0 && nut_phai ==1){
               goto cai_dat;
            }    
        } 
        cai_dat:
        //che_do=1; 
        if(che_do != 0 ){
        den_bao=0;  
        vi_tri_cai_dat=0;
        if(che_do==1){
             rtc_get_time(&gio_cd,&phut_cd,&giay_cd); 
             lcd_gotoxy(0,0);
             lcd_puts("    CAI DAT GIO     "); 
             hien_thi_chuoi(gio_cd,phut_cd,giay_cd,0,0,1);
             lcd_gotoxy(5,1);
             _lcd_write_data(0x0F);  // nhap nhay con tro
        }
        if(che_do==2){
            rtc_get_date(&thu_cd, &ngay_cd,&thang_cd,&nam_cd); 
            lcd_gotoxy(0,0);
            lcd_puts("    CAI DAT NGAY    ");
            hien_thi_chuoi(ngay_cd,thang_cd,nam_cd,1,0,1); 
            lcd_gotoxy(5,1);
            _lcd_write_data(0x0F);
        } 
        
        }
        
    } 
    //vao che de cai dat ngay va gio
    while(che_do){ 
         giaotiep_hc05();
        // nhan nut qua phai 
    {
        if(nut_tang ==1 && nut_giam==1 && nut_trai==1 && nut_phai==0 && da_nhan_phai==0){
            vi_tri_cai_dat++;  
            if(vi_tri_cai_dat>5){  
                vi_tri_cai_dat=0;   
               
                
            }
            lcd_gotoxy(vi_tri[vi_tri_cai_dat],1);
              da_nhan_phai=1;
            
            
        }
        if(nut_phai==1){
            da_nhan_phai=0;
        }   
    }
        // nhan nut qua trai
    {
         if(nut_tang ==1 && nut_giam==1 && nut_trai==0 && nut_phai==1 && da_nhan_trai==0){
            vi_tri_cai_dat--;  
            
            
            if(vi_tri_cai_dat > 5 ){  
                vi_tri_cai_dat=5;
               
                
            }
            lcd_gotoxy(vi_tri[vi_tri_cai_dat],1);
            da_nhan_trai=1;
            
            
        }
        if(nut_trai==1){
            da_nhan_trai=0;
        }   
    }
    // nhan nut tang   
    if(nut_tang ==0 && nut_giam==1 && nut_trai==1 && nut_phai==1 && da_nhan_tang==0 ){
             dem++; 
                
        if(che_do==1){
            switch(vi_tri_cai_dat){
             case 0:
                 gio_cd=gio_cd+10;
             break;
             case 1:
                 gio_cd++;
             break; 
             case 2:
                 phut_cd=phut_cd+10;
             break; 
             case 3:
                 phut_cd++;
             break; 
             case 4:
                 giay_cd=giay_cd+10;
             break; 
             case 5:
                 giay_cd++;
             break; 
              
            }
        }
        else if(che_do==2){
            // tang cho hang 2: ngay, thang, nam  
            switch (vi_tri_cai_dat){
            case 0:
            ngay_cd=ngay_cd+10;
             break;
             case 1 :
                 ngay_cd++;
             break; 
             case 2:
                 thang_cd=thang_cd+10;
             break; 
             case 3:
                 thang_cd++;
             break; 
             case 4:
                 nam_cd=nam_cd+10;
             break; 
             case 5:
                 nam_cd++;
             break;  
            }
           
         
             
             }
             
             
             
            da_nhan_tang=1;  
            //hieu chinh ngay gio
            hieuchinh_ngaygio(); 
            
            if(che_do==1){
                hien_thi_chuoi(gio_cd,phut_cd,giay_cd,0,0,1);   
                             
                lcd_gotoxy(vi_tri[vi_tri_cai_dat],1); 
            }
            else if(che_do==2){
                hien_thi_chuoi(ngay_cd,thang_cd,nam_cd,1,0,1);   
                             
                lcd_gotoxy(vi_tri[vi_tri_cai_dat],1); 
            }
        
   }      
             
             
            
        
        if(nut_tang==1){
            da_nhan_tang=0;
        }
       
        // nhan nut giam      
        if(nut_tang ==1 && nut_giam==0 && nut_trai==1 && nut_phai==1 && da_nhan_giam==0 ){
             if(che_do==1){
                switch(vi_tri_cai_dat){
                     case 0:
                         gio_cd=gio_cd-10;
                     break;
                     case 1:
                         gio_cd--;
                     break; 
                     case 2:
                         phut_cd=phut_cd-10;
                     break; 
                     case 3:
                         phut_cd--;
                     break; 
                     case 4:
                         giay_cd=giay_cd-10;
                     break; 
                     case 5:
                         giay_cd--;
                     break;  
                }
             }
             // tang cho hang 2: ngay, thang, nam 
             if(che_do==2){
                switch(vi_tri_cai_dat){
                    case 0:
                    ngay_cd=ngay_cd-10;
                    break;
                    case 1 :
                    ngay_cd--;
                    break; 
                    case 2:
                    thang_cd=thang_cd-10;
                    break; 
                    case 3:
                    thang_cd--;
                    break; 
                    case 4:
                    nam_cd=nam_cd-10;
                    break; 
                    case 5:
                    nam_cd--;
                    break;  
                
                }
             }  
             
        
        
         
            
             
            da_nhan_giam=1;  
            
            hieuchinh_ngaygio();  
            if(che_do==1){
                hien_thi_chuoi(gio_cd,phut_cd,giay_cd,0,0,1);   
                             
                lcd_gotoxy(vi_tri[vi_tri_cai_dat],1); 
            }
            else if(che_do==2){
                hien_thi_chuoi(ngay_cd,thang_cd,nam_cd,1,0,1);   
                             
                lcd_gotoxy(vi_tri[vi_tri_cai_dat],1); 
            }
        
         
             
             
            
        }
    
        if(nut_giam==1){
            da_nhan_giam=0;
        } 
         
        //luu va thoat che do cai dat
        if(nut_tang ==1 && nut_giam==1 && nut_trai==0 && nut_phai==0 ){
            _lcd_write_data(0x0C);  
            if(che_do==1){
                rtc_set_time(gio_cd,phut_cd,giay_cd);
            
            }
            else if(che_do==2){
                 rtc_set_date(thu_cd, ngay_cd,thang_cd,nam_cd);
            
            }
           
            che_do=0;
            den_bao=1; 
            
                     
        }
       //thoat va khong luu
        if(nut_trai==0 && nut_giam==0 && nut_phai==1 && nut_tang==1){
            _lcd_write_data(0x0C);
            
            che_do=0;
            den_bao=1;   
            
        }
    }   
}
void hien_thi_chuoi(unsigned char data1, unsigned char data2, unsigned char data3,unsigned char ngay_gio, unsigned char cot, unsigned char hang ){
        
       
      if(ngay_gio ==0){
        
           sprintf(chuoi,"     %2.2u:%2.2u:%2.2u      ",data1,data2,data3);
           
      }  
       else{ 
       
          sprintf(chuoi,"     %2.2u/%2.2u/%2.2u       ",data1,data2,data3); 
      } 
     
      lcd_gotoxy(cot,hang);
      lcd_puts(chuoi);
}     
void kiem_tra_nut_nhan(int thoi_gian){
      int time;       
      for(time=0;time<thoi_gian;time++){
        giaotiep_hc05();
        xu_ly_nut();
        delay_ms(1);
      }
    
}





// Declare your global variables here

unsigned int adc_data;
// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
adc_data=ADCW;
}

// Read the AD conversion result
// with noise canceling
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
#asm
    in   r30,mcucr
    cbr  r30,__sm_mask
    sbr  r30,__se_bit | __sm_adc_noise_red
    out  mcucr,r30
    sleep
    cbr  r30,__se_bit
    out  mcucr,r30
#endasm
return adc_data;

}
void hienthi_nhietdo(){
     nhiet_do=read_adc(6);
       nhiet_do=500/1024.0*nhiet_do;
    if(nhiet_do>9){
        sprintf(chuoi,"nhiet do:%d",nhiet_do); 
    }
    else{
        sprintf(chuoi,"nhiet do:%d ",nhiet_do);
    }   
       
    test[3]=nhiet_do;
    lcd_gotoxy(0,0);
    lcd_puts("  do an hoc phan 2");
    lcd_gotoxy(4,1);
    
    lcd_puts(chuoi);
}

void main(void)
{
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(1<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=1 Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(1<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 500.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTD
// I2C SDA bit: 3
// I2C SCL bit: 2
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: On
// Square wave frequency: 1Hz
rtc_init(0,1,0);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 20
lcd_init(20);

// Global enable interrupts
#asm("sei")
}
DDRD.4=DDRD.5=DDRD.6=DDRD.7 = 1;
lcd_gotoxy(0,0);
//lcd_puts("do an hoc phan 2");
lcd_gotoxy(0,1);
//lcd_puts("Nguyen Ba Phi Hung");
rtc_set_time(23,59,59);
//rtc_set_time(gio_cd,phut_cd,giay_cd);
rtc_set_date(3,31,12,20);
delay_ms(100);

 
while (1)
      {     
    
       
        for(m=0;m<15;m++){
            rtc_get_time(&gio,&phut,&giay);
            kiem_tra_nut_nhan(100);  //  delay 100ms giua cac lan doc
            rtc_get_date(&thu, &ngay,&thang,&nam);
            hien_thi_chuoi(gio,phut,giay,0,0,0); 
            hien_thi_chuoi(ngay,thang,nam,1,0,1); 
            kiem_tra_nut_nhan(100); //  delay 100ms giua cac lan doc   
        }                                                                               
         
          
         
        for(m=0;m<5;m++){
            hienthi_nhietdo();   
           
            
            kiem_tra_nut_nhan(250); 
        }
         
        
        giaotiep_hc05(); 
       
        
      }
}
