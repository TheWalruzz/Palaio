module Palaio.Utilities.Vector;

import std.algorithm;

class Vector(T)
{
    private:
        T _container[];

    public:
        this()
        {
            _container.length = 0;
        }

        this(T arr[])
        {
            _container.length = arr.length;
            _container = arr;
        }

        ~this()
        {
            clear();
        }

        void pushBack(T element)
        {
            _container.length++;
            _container[_container.length-1] = element;
        }

        void pushFront(T element)
        {
            _container.length++;

            // move every element by one to the back
            for(int i = _container.length-1; i > 0; i--)
                _container[i] = _container[i-1];

            _container[0] = element;
        }

        void remove(int position)
        {
            // just move everything by one to the front from this position
            for(int i = position; i < _container.length-1; i++)
                _container[i] = _container[i+1];

            _container.length--;
        }

        ref T opIndex(int index)
        {
            return _container[index];
        }

        void opIndexAssign(T value,int index)
        {
            _container[index] = value;
        }

        T popBack()
        {
            T temp = _container[_container.length-1];

            remove(_container.length-1);

            return temp;
        }

        T popFront()
        {
            T temp = _container[0];

            remove(0);

            return temp;
        }

        void clear()
        {
            _container.length = 0;
        }

		void sort(U)(U comp)
		{
			std.algorithm.sort!(comp)(_container);
		}

		void sort()
		{
			std.algorithm.sort(_container);
		}

		@property int length() { return _container.length; }
}
