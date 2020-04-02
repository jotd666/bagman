#ifndef THREADCONDITION_H
#define THREADCONDITION_H

#include "SDL/SDL.h"

class ThreadCondition
{
 public:
    ThreadCondition()
    {
	m_cv = SDL_CreateCond();
	m_mutex = SDL_CreateMutex();
    }

    ~ThreadCondition()
    {
	SDL_DestroyCond(m_cv);
	SDL_DestroyMutex(m_mutex);
    }

    void lock()
    {
	SDL_LockMutex(m_mutex);
    }

    void unlock()
    {
	SDL_UnlockMutex(m_mutex);
    }

    void broadcast()
    {
	SDL_CondBroadcast(m_cv);
    }

    void wait()
    {
	SDL_CondWait(m_cv, m_mutex);
    }

 private:
    ThreadCondition(const ThreadCondition &);
    ThreadCondition &operator=(const ThreadCondition &);
    
    SDL_mutex *m_mutex;
    SDL_cond  *m_cv;

    
};
#endif
