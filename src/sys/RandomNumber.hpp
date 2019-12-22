#ifndef RANDOMNUMBER_H_INCLUDED
#define RANDOMNUMBER_H_INCLUDED

class RandomNumber
{
   public:
   static const int rand_max;
   static void randomize();
   static int rand(int max_value);
   static bool happens_once_out_of(int one_time_out_of);
};


#endif // RANDOMNUMBER_H_INCLUDED
