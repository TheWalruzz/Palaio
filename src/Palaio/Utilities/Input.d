module Palaio.Utilities.Input;

import std.concurrency;
import core.sync.mutex;

import Palaio.Utilities.Vector;
import Palaio.Utilities.Log;

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
		__gshared bool _flag;

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
			synchronized(_inputMutex)
				_flag = true;

			while(Input.getInstance().flag)
			{
				if(SDL_PeepEvents(&e, 1, SDL_GETEVENT, SDL_FIRSTEVENT, SDL_LASTEVENT) > 0)
				{
					synchronized(_inputMutex)
					{
						_eventQueue.pushBack(e);

						if(e.type == SDL_QUIT)
							_flag = false;
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

				if(event.type == SDL_QUIT)
					_flag = false;
			}
		}

		/**
		* Pops an event from the front of the event queue.
		* Returns: Popped event or empty event with field 'type' equal to 0 if queue was empty.
		*/
		SDL_Event popEvent()
		{
			SDL_Event temp;

			// called here because popEvent would be called in a loop anyway
			// just to repopulate the SDL's event queue.
			// must be called by main thread
			SDL_PumpEvents();

			synchronized(_inputMutex)
				if(_eventQueue.length > 0)
					temp = _eventQueue.popFront();

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
				_eventQueue.clear();
		}

		/// Terminates the input thread.
		void terminateThread()
		{
			synchronized(_inputMutex)
				_flag = false;
		}

		/// Sets the thread state flag to f.
		/// If set to false, the thread is terminated.
		@property void flag(bool f)
		{
			synchronized(_inputMutex)
				_flag = f;
		}

		/// Gets the thread state flag.
		@property bool flag()
		{
			bool temp;

			synchronized(_inputMutex)
				temp = _flag;

			return temp;
		}
}
