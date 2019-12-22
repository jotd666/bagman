#include "AnimatedSequence.hpp"
#include "MyFile.hpp"
#include "GfxFrameSet.hpp"

AnimatedSequence::~AnimatedSequence()
{
}

AnimatedSequence::AnimatedSequence(const MyString &dir_name, int update_rate, Type type, bool transparent): AnimatedObject(type,transparent)
{
    ENTRYPOINT("ctor");
    m_update_rate = update_rate;
    m_elapsed = 0;

    m_alpha = 255;

    set_name(dir_name.basename());

    MyFile f(dir_name);

    if (!f.is_directory())
    {
        abort_run("%q is not a valid directory",dir_name);
    }
    std::list<MyString> image_files;


    f.dir(image_files,true); // no dirs

    int nb_frames = image_files.size();


    if (nb_frames == 0)
    {
        abort_run("no image files found in %q",dir_name);
    }

    set_nb_frames(nb_frames);


    m_frames.resize(nb_frames);

    std::list<MyString>::const_iterator it;

    int i = 0;

    FOREACH(it,image_files)
    {
        MyString image_name = dir_name / *it;

        if (m_transparent)
        {
            m_frames[i].load(image_name,0xFF00FF);
        }
        else
        {
            m_frames[i].load(image_name);
        }
        i++;
    }

    const ImageFrame &imgf = m_frames[0];

    set_w(imgf.get_w());
    set_h(imgf.get_h());

    EXITPOINT;
}


void AnimatedSequence::update(int elapsed)
{
    ENTRYPOINT(update);

    if (get_anim_type() != CUSTOM)
    {
        m_elapsed += elapsed;
        while (m_elapsed > m_update_rate)
        {
            m_elapsed -= m_update_rate;
            next();
        }
    }
    EXITPOINT;
}

#include "ScaleSize.hpp"

void AnimatedSequence::render(Drawable &screen) const
{
    const ImageFrame &imgf = m_frames[get_current_frame()];
#ifndef _NDS
    SDL_SetAlpha(imgf.data(),SDL_SRCALPHA,m_alpha);
#endif
    const SDLRectangle &r= get_bounds();

    imgf.render(screen,r.x-10,r.y,r.w,r.h);
}
