module Palaio.Utilities.Log;

import Palaio.Config;

import std.stdio;
import std.string;
import std.datetime;

/// Singleton class implementing the simple logger.
class Log
{
    private:
		static Log _instance;
        File _f;

        string getTime()
        {
            SysTime cl = Clock.currTime();
            cl.fracSec(cast(FracSec) 0); // get rid of fractional seconds - they look nasty!
            return cl.toSimpleString(); // return as simple representation
        }

		~this()
        {
            _f.close();
        }

        this()
        {
            _f=File(LOGFILE, "w"); // create/clear file
            _f.writefln("Log @ %s", getTime()); // add timestamp
            _f.close(); // close, so we could append later
        }

    public:
		/**
		* Gets instance of logger.
		* Returns: Reference to Log object.
		*/
        static ref Log getInstance()
		{
			if(_instance is null)
				_instance = new Log();

			return _instance;
		}

		/**
		* Writes a new entry to the log.
		* Params:
		*	text =			Text to be written.
		*/
        bool write(string text)
        {
			_f = File(LOGFILE, "a"); // ...aaand we open it again
            if(_f.isOpen())
            {
                _f.writefln("%s\t%s", getTime(),text);
				_f.close();
                return true;
            }

            return false;
        }
}
