#ifndef OPTIONSBASE_H_INCLUDED
#define OPTIONSBASE_H_INCLUDED

#include "Abortable.hpp"

class OptionsBase : public Abortable
{
public:
    DEF_GET_STRING_TYPE(OptionsBase);

    OptionsBase();

    void save();


    inline bool is_original_gfx() const
    {
        return original_gfx;
    }
    enum SkillLevel { TRAINER, EASY, MEDIUM, HARD, HARDEST };
    enum ExtraLifeScore { EXTRA_LIFE_30000 = 30000, EXTRA_LIFE_40000 = 40000 };

    inline SkillLevel get_skill_level() const
    {
        return skill_level;
    }
    inline ExtraLifeScore get_extra_life_score() const
    {
        return extra_life_score;
    }
    const char *get_skill_level_str() const;

    void harder_extra_life_score();
    void easier_extra_life_score();
    void harder_skill_level();
    void easier_skill_level();
private:
    bool original_gfx;
    SkillLevel skill_level;
    ExtraLifeScore extra_life_score;
    bool changed;

    MyString settings_file;

};

#endif // OPTIONSBASE_H_INCLUDED
