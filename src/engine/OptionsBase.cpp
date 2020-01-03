#include "OptionsBase.hpp"
#include "DirectoryBase.hpp"
#include "MyFile.hpp"

static const char *skill_level_str[] = {"trainer","easy","medium","hard","hardest"};


const char *OptionsBase::get_skill_level_str() const
{
  return skill_level_str[skill_level];
}


void OptionsBase::harder_extra_life_score()
{
  if (extra_life_score < EXTRA_LIFE_40000)
    {
      extra_life_score = EXTRA_LIFE_40000;
      //changed = true;
    }
}
void OptionsBase::easier_extra_life_score()
{
  if (extra_life_score > EXTRA_LIFE_30000)
    {
      extra_life_score = EXTRA_LIFE_30000;
      //changed = true;
    }

}
void OptionsBase::harder_skill_level()
{
  if (skill_level < HARDEST)
    {
      skill_level = SkillLevel((int)skill_level+1);
      //changed = true;
    }

}
void OptionsBase::easier_skill_level()
{
  if (skill_level > TRAINER)
    {
      skill_level = SkillLevel((int)skill_level-1);
      //changed = true;
    }

}
OptionsBase::OptionsBase()
{
  ENTRYPOINT(ctor);






  EXITPOINT;
}


