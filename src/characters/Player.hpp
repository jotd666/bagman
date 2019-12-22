#ifndef PLAYER_H_INCLUDED
#define PLAYER_H_INCLUDED

#include "HumanCharacter.hpp"
#include "PlayerControls.hpp"
#include "PointerVector.hpp"
#include "GfxObject.hpp"

class Drawable;
class GfxFrameSet;
class GfxFrame;

class MPLevel;
class SoundSet;
class Fonts;

class Player : public HumanCharacter
{
public:


    DEF_GET_STRING_TYPE(Player);
    Player();
    ~Player();

    void play_pick_sound();

    void init(MPLevel *level);


    bool owns(GfxObject::Type t) const;


    void level_init(int x_arcade,int y, int current_screen, FullDirection d);

    void render(Drawable &d) const;

    void set_level_end();

    void set_held_item(GfxObject *o);
    void release_held_item();

    int get_nb_lives() const
    {
        return m_lives;
    }

    void remove_held_item();

    GfxObject *get_held_item()
    {
        return m_item_held;
    }
    void add_score(int sc);

    inline int get_score() const
    {
        return m_score;
    }
    void new_game();
protected:
    virtual void update_alive(int elapsed_time);
    virtual void on_die();

private:
    DEF_CLASS_COPY(Player);

    AnimatedSprite m_cling_frames;
    int get_held_bag_value() const;
    void align_item(GfxObject *ob);
    void handle_weapons();

    MoveType handle_left_right(const PlayerControls::Status &input);
    MoveType handle_up_down(const PlayerControls::Status &input);
    void handle_walk(int elapsed_time, const PlayerControls::Status &input);
    void handle_climb(int elapsed_time, const PlayerControls::Status &input);
    void handle_pickups(const PlayerControls::Status &input);


    void handle_cling();
    void handle_release();
    virtual int get_max_move_skip() const;


    int m_lives;
    int m_pick_index;
    int m_pick_timer;
    int m_pick_life;
    bool m_extra_life_awarded;
    int m_extra_life_score;
    GfxObject *m_item_held;
    const GfxObject *m_barrow;
    int m_score;
    bool m_allow_pick;

};

#endif // PLAYER_H_INCLUDED
