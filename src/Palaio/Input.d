module Palaio.Input;

import core.thread;
import core.sync.mutex;

import Palaio.Utilities.Vector;

import Derelict.SDL2.sdl;

pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictUtil.lib");

/// Singleton class implementing the mouse input
class Input
{
	private:
		static Input _instance = null;
		Thread _inputThread;
		Vector!SDL_Event _eventQueue;
		Mutex _inputMutex;

		this()
		{
			thread_init();
			_eventQueue = new Vector!SDL_Event();
			_inputMutex = new Mutex();
			_inputThread = new Thread(&handler);
			_inputThread.start();
		}

	public:
		/**
		* Gets the singleton instance of object.
		* Returns: Reference to the object.
		*/
		static ref Input getInstance()
		{
			if(_instance is null)
				_instance = new Input();

			return _instance;
		}

		/// Function used for threaded polling of input events.
		static void handler()
		{
			SDL_Event e;

			while(true)
			{
				synchronized(_instance.mutex)
				{
					if(SDL_PollEvent(&e))
						_instance.pushEvent(e);
				}
			}
		}

		/**
		* Pushes an input event to the event queue.
		* Params:
		*	event =			Event to push.
		*/
		void pushEvent(SDL_Event event)
		{
			synchronized(_inputMutex)
			{
				_eventQueue.pushBack(event);
			}
		}

		/**
		* Pops an event from the front of the event queue.
		* Returns: Popped event or empty event with field 'type' equal to 0 if queue was empty.
		*/
		SDL_Event popEvent()
		{
			SDL_Event temp;

			synchronized(_inputMutex)
			{
				if(_eventQueue.length > 0)
					temp = _eventQueue.popFront();
				else
					temp.type = 0;
			}

			return temp;
		}

		/// Pauses the input handler.
		/// Useful if you don't want the queue to get filled while not checking for any new input.
		void pauseInput()
		{
			_inputMutex.lock();
		}

		/// Unpauses the input handler.
		void unpauseInput()
		{
			_inputMutex.unlock();
		}

		/**
		* Gets the mutex used in input handling.
		* Returns: Reference to mutex.
		*/
		@property ref Mutex mutex() { return _inputMutex; }
}
