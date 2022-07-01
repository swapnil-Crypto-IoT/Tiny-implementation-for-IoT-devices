//=========================================================================================
//      Global Variable Declaration
//=========================================================================================
unsigned long temp1, temp2;
//char ch[5]; // 1 byte =8 bit, no. of required bits 64 bit = 8 byte to display on LCD
char i, j; // repeatative used in many functions
char sbox[16] = {0x2,0x9,0x7,0xE,0x1,0xC,0xa,0x0,0x4,0x3,0x8,0xD,0xF,0x6,0x5,0xB};   // SBOX ANU
char p[32] = {20,16,28,24,17,21,25,29,22,18,30,26,19,23,27,31,11,15,3,7,14,10,6,2,9,13,1,5,12,8,4,0}; // P-layer ANU


//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : Left circular shifted value of msb_bits by 3
//============================================================================================
unsigned long lcs_3(unsigned long msb_32, unsigned long *lcs_msb_32)
{
        *lcs_msb_32 = ((msb_32&0x1fffffff)<<3)|((msb_32&0xe0000000)>>(32-3));
}

//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : Right circular shifted value of msb_bits by 8
//============================================================================================
unsigned long rcs_8(unsigned long msb_32, unsigned long *rcs_msb_32)
{
        *rcs_msb_32 = ((msb_32&0xffffff00)>>8)|((msb_32&0x000000ff)<<(32-8));
}
//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : New substituted value for each nibble in n_nibble
//============================================================================================
unsigned long s_box(unsigned long msb_32, unsigned long *n_nibble)
{
     unsigned long a[8];
     *n_nibble=0;
 for(i=0;i<32;i=i+4)
 {
   a[(i*1)/4]= sbox[((msb_32>>(i))&0xf)];
   *n_nibble |= a[(i*1)/4] << i;
 }

}

//============================================================================================
// Input        : msb_bits (32 bits)
// Output        : Permuted value for each bits in msb_32 bits
//============================================================================================
unsigned long p_box(unsigned long msb_32, unsigned long *p_msb_32)
{
        *p_msb_32=0;
        for (i=0;i<32;i++)
        {
                 *p_msb_32 |= ((msb_32>>i)&0x1)<<p[i];
        }

}

//============================================================================================
//       ANU Key Scheduling
//============================================================================================
unsigned long key_schedule_1(unsigned long *rk)
{
   unsigned long Key[4]={0x00000000,0x00000000,0x00000000,0x00000000}; //hard coded 128 bit master key

        // if(j==1)
         {rk[0] = Key[3];}
         //if(j==2)
         //{b[0] = Key[1];}
      for(i=0;i<25;i++)
      {
        temp1 = temp2 = 0;
        temp1 = Key[0];
        //temp2 = Key[1];

        // Circular left shift by 13
        Key[0]  = ((temp1&0x0007ffff)<<13) |((Key[1]&0xfff80000)>>(32-13)) ;
        Key[1]  = ((Key[1]&0X0007ffff)<<13) |(((Key[2]&0xfff80000)>>(32-13)));
        Key[2]  = ((Key[2]&0x0007ffff)<<13) |(((Key[3]&0Xfff80000))>>(32-13));
        Key[3]  = ((Key[3]&0X0007ffff)<<13) |(((temp1&0Xfff80000))>>(32-13));    //left circular shift by 13

        // sub-byte
        temp1 = sbox[Key[3]&0xf] ;
        temp2 = sbox[((Key[3])>>4)&0xf];
        temp1 = ((temp2&0xf)<<4)| temp1 ;
        Key[3] = (Key[3]&0xffffff00)|(temp1); // SBOX[K7,K6,K5,K4] and SBOX[K3,K2,K1,K0]

        // RCi xor [k63-k59]
        temp1 = (Key[2] & 0xf8000000) >> (32-5);
        temp1 = temp1 ^ ((i)&0x1f);
        Key[2]=  (Key[2] & 0x07ffffff) | ((temp1 & 0x1f)<<(32-5))  ;

        {rk[i+1] = Key[3];}
        }

} // KSA end

//============================================================================================
//       ANU round function
//============================================================================================
unsigned long anu_round(unsigned long msb, unsigned long lsb, unsigned long rk, unsigned long *msbout, unsigned long *lsbout)
{
  unsigned long state=0,trail_1=0,trail_2=0;

  lcs_3(msb,&state);
  s_box(state,&trail_1);

  rcs_8(msb,&state);
  s_box(state,&trail_2);

  state = trail_1 ^ trail_2 ^ rk ^ lsb;


  p_box(msb,&trail_1);
  p_box(state,&trail_2);

  //swap
  lsb = trail_1;
  msb = trail_2;

  //joining 64 bits = msb_bits + lsb_bits
  //*msbout =0;
  //*lsbout =0;
  *msbout = msb;
  *lsbout = lsb;

} // ANU Round function end

void setup() {
  // put your setup code here, to run once:
 Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

 unsigned long r_k[25]={0}, msb_out=0, lsb_out=0;
 unsigned long pt[2] = {0x00000000, 0x00000000};      // hardcoded plaintext
 int i;
 
 unsigned long StartTime = micros();
 // ANU KSA calling function
 key_schedule_1(r_k);           // key scheduling function call to store all the key
 
  
 
 // Round function calling
 msb_out = pt[0];
 lsb_out = pt[1];

 for(i=0;i<25;i++)
    {
      
      anu_round(msb_out,lsb_out, r_k[i], &msb_out, &lsb_out);
      if(i==24)
      {
        pt[0]=msb_out;
        pt[1]=lsb_out;
       }

     }// round = 25 for end

   unsigned long CurrentTime = micros();
  unsigned long ElapsedTime = CurrentTime - StartTime;
  Serial.println(ElapsedTime);
  
/*
 Serial.println(pt[0],HEX);
 delay(100);
 Serial.println(pt[1],HEX);
 delay(100);
*/
}
