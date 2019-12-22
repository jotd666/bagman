#include "OptionsBase.hpp"
#include "DirectoryBase.hpp"
#include "PrmIo.hpp"
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
      changed = true;
    }
}
void OptionsBase::easier_extra_life_score()
{
  if (extra_life_score > EXTRA_LIFE_30000)
    {
      extra_life_score = EXTRA_LIFE_30000;
      changed = true;
    }

}
void OptionsBase::harder_skill_level()
{
  if (skill_level < HARDEST)
    {
      skill_level = SkillLevel((int)skill_level+1);
      changed = true;
    }

}
void OptionsBase::easier_skill_level()
{
  if (skill_level > TRAINER)
    {
      skill_level = SkillLevel((int)skill_level-1);
      changed = true;
    }

}
OptionsBase::OptionsBase()
{
  ENTRYPOINT(ctor);

  original_gfx = false;
  extra_life_score = EXTRA_LIFE_30000;
  skill_level = EASY;

  changed = false;
  debug("loading settings...");
  settings_file = DirectoryBase::get_root() / "settings";
  if (MyFile(settings_file).exists())
    {
      try
      {
	PrmIo fr(settings_file);
	fr.start_block_verify("SETTINGS");
	fr.read("original_gfx",original_gfx);
	skill_level = (SkillLevel)fr.READ_ENUM("skill_level",skill_level_str);
	extra_life_score = (ExtraLifeScore)fr.read_integer("extra_life_score");
	fr.end_block_verify();
      }
      catch (const Cause &c)
      {
	// pass
      }
      debug("settings loaded");
    }
  else
    {
      debug("No settings found");
    }

  EXITPOINT;
}

void OptionsBase::save()
{
  ENTRYPOINT(save);

  if (changed)
    {
      PrmIo fw;
      fw.create(settings_file);
      fw.start_block_write("SETTINGS");
      fw.write("original_gfx",original_gfx);
      fw.write("skill_level",skill_level_str[skill_level]);
      fw.write("extra_life_score",(int)extra_life_score);
      fw.end_block_write();
    }
  changed = false;

  EXITPOINT;
}
