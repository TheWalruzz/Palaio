module Palaio.Utilities.Input;

import std.concurrency;
import core.sync.mutex;

import Palaio.Utilities.Vector;
import Palaio.Utilities.Log;

import std.stdio;

import Derelict.SDL2.sdl;

pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictUtil.lib");

/// Singleton class implementing the mouse input.
class Input
{
	private:
		__gshared Input _instance = null;
		__gshared Vector!SDL_Event _eventQueue;
		__gshared Mutex _inputMutex;

		static Log _l;

		this()
		{
			_l = Log.getInstance();

			_eventQueue = new Vector!SDL_Event();
			_inputMutex = new Mutex();
		}

		~this()
		{
		}

	public:
		/**
		* Gets the singleton instance of object.
		* Returns: Reference to the object.
		*/
		static ref Input getInstance()
		{
			if(_instance is null)
			{
				_instance = new Input();

				spawn(&handler);
				_l.write("Started input thread");
			}

			return _instance;
		}

		/// Method used for polling of input events in a separate thread.
		static void handler()
		{
			SDL_Event e;
			bool flag = true;

			SDL_EventState(SDL_MOUSEBUTTONDOWN, SDL_ENABLE);

			while(flag)
			{
				if(SDL_WaitEvent(&e))
				{
					synchronized(_inputMutex)
					{
						_eventQueue.pushBack(e);

						if(e.type == SDL_QUIT)
							flag = false;
					}
				}
			}
		}

		/**
		* Pushes an event to the event queue.
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

			/*synchronized(_inputMutex)
			{
				if(_eventQueue.length > 0)
				{
					temp = _eventQueue.popFront();
					writefln("popped: %d", temp.type);
				}
			}*/

			SDL_PollEvent(&temp);

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

		/// Clears the event queue.
		void clearQueue()
		{
			synchronized(_inputMutex)
			{
				_eventQueue.clear();
			}
		}
}
