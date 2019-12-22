#ifndef THREADCONDITION_H
#define THREADCONDITION_H

#include <pthread.h>

class ThreadCondition
{
 public:
    ThreadCondition()
    {
	pthread_cond_init(&m_cv,NULL);
	pthread_mutex_init(&m_mutex,NULL);
    }

    ~ThreadCondition()
    {
	pthread_cond_destroy(&m_cv);
	pthread_mutex_destroy(&m_mutex);

    }

    void lock()
    {
	pthread_mutex_lock(&m_mutex);
    }

    void unlock()
    {
	pthread_mutex_unlock(&m_mutex);
    }

    void broadcast()
    {
	pthread_cond_broadcast(&m_cv);

    }

    void wait()
    {
	pthread_cond_wait(&m_cv,&m_mutex);
    }

 private:
    ThreadCondition(const ThreadCondition &);
    ThreadCondition &operator=(const ThreadCondition &);
    
    pthread_mutex_t m_mutex;
    pthread_cond_t  m_cv;

    
};
#endif
