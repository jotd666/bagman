#ifndef HUMANCHARACTER_H_INCLUDED
#define HUMANCHARACTER_H_INCLUDED

#include "AnimatedSprite.hpp"
#include "SoundSet.hpp"
#include "Character.hpp"
#include "FrameCouple.hpp"
#include "GfxPalette.hpp"
#include "Elevator.hpp"

class MPLevel;
class GfxObject;
class TileGrid;

class HumanCharacter : public Character
{
public:
    ~HumanCharacter();

    enum State  { STATE_WALK, STATE_IN_AIR, STATE_CLIMB, STATE_IN_WAGON,
                  STATE_IN_MOVING_ELEVATOR, STATE_CLING, STATE_LAND
                };

    int get_x_boundary(int x, int margin) const;

    enum LifeState { ALIVE, /* character is alive and moving */
                     DYING, /* has been hit */
                     DEAD   /* player is dead, guard is "sleeping" */
                   };

    enum FullDirection { FD_LEFT = 0x40, FD_RIGHT=0x80, FD_UP=0x10, FD_DOWN=0x20 };


    HumanCharacter(SoundSet::SoundId walk_sound,SoundSet::SoundId climb_sound);

    inline int get_direction_sign() const
    {
        return m_direction == RIGHT ? 1 : -1;
    }


    inline MPLevel *get_level()
    {
        return m_level;
    }
    inline const MPLevel *get_level() const
    {
        return m_level;
    }
    void set_life_state(LifeState ls);

    inline LifeState get_life_state() const
    {
        return m_life_state;
    }

    State get_state() const
    {
        return m_position;
    }
    // only for guards

    void fall_from_ladder();

    virtual void render(Drawable &d) const;

    void kill();
    void set_position(State pos);
    void update(int elapsed_time);


    int get_stunned_duration() const
    {
        return m_stunned_duration;
    }

    FullDirection get_opposite_direction(FullDirection d) const;

    void play_move_sound();

protected:

    virtual void update_alive(int elapsed_time) = 0;
    virtual void on_die();
    virtual int get_max_move_skip() const;

    void handle_gravity(int elapsed_time);

    int m_walk_pos;
    int m_climb_pos;
    int m_move_skip;
    int m_update_rate;
    int m_actual_nb_walk_frames;

    bool m_level_end;

    typedef std::pair<int,bool> MovePos;

    MyVector<MovePos> m_walk_sequence;
    MyVector<MovePos> m_climb_sequence;

    void add_walk_pos(int fn, bool moves);
    void add_climb_pos(int fn, bool moves);

    void align_x_on_ladder();

    enum FrameIndex { WALK, CLIMB, FALL };
    enum MoveType { MT_BLOCKED, MT_ADVANCE_FRAME, MT_WAIT_FRAME };

    MoveType m_move_type; // used for synchronized sound play
    FrameIndex m_frame_index;

    MoveType try_to_move_right();
    MoveType try_to_move_left();
    MoveType try_to_move_up();
    MoveType try_to_move_down();

    bool can_climb_down() const;
    bool can_climb_up() const;
    bool can_move_right() const;
    bool can_move_left() const;

    void apply_gravity(int elapsed_time);


    void init(MPLevel *level);
    void level_init(int x_arcade, int y,int current_screen);
    GfxObject *get_pickable_bonus();
    virtual bool may_fall() const;

    void align_y_on_grid();

    void set_walk_frames(const GfxPalette::LeftRight &f);
    void set_special_frames(const GfxFrameSet &special);

    void set_stunned_frame_update_rate(int ur);

    State m_position;
    int m_walk_timer;
    int m_stunned_duration;
    AnimatedSprite m_climb_frame;

private:
    FrameCouple m_walk_frame;
    AnimatedSprite m_fall_frame;
    AnimatedSprite m_crash_frame;
    AnimatedSprite m_stunned_frame;
    int m_fall_timer;
    LifeState m_life_state;
    SoundSet::SoundId m_walk_sound;
    SoundSet::SoundId m_climb_sound;
    bool adapt_to_slopes(int x_test, int y_test);
    bool can_move_laterally(int x_test) const;
    int get_walk_dx() const;
    int get_climb_dy() const;

    void move_character_in_elevator(const Elevator *e, Elevator::CharacterContained cc);
    void advance_walk_pos();
    void advance_climb_pos();
    bool vertical_move(int delta_y);
    bool lateral_move(int delta_x);
    bool m_from_cling;
    int m_y_fall;
    State m_position_before_fall;
    bool m_fall_from_ladder;





};

#endif // CHARACTER_H_INCLUDED
