module Palaio.Utilities.Log;

import Palaio.Config;

import std.stdio;
import std.string;
import std.datetime;

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

            _f=File(LOGFILE, "a"); // ...aaand we open it again
        }

    public:
        static ref Log getInstance()
		{
			if(_instance is null)
				_instance = new Log();

			return _instance;
		}

        bool write(string text)
        {
            if(_f.isOpen())
            {
                _f.writefln("%s\t%s", getTime(),text);
                return true;
            }

            return false;
        }
}
