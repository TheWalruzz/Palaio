module Palaio.Utilities.Vector;

import std.algorithm;

/// Class implemeting dynamic data container a'la vector from STL.
class Vector(T)
{
	private:
		T _container[];

	public:
		/// Creates an empty container.
		this()
		{
			_container.length = 0;
		}

		/**
		* Creates a new container with data from an array.
		* Params:
		*	array =			Array with data to be added.
		*/
		this(T array[])
		{
			this();

			for(int i = 0; i < array.length; i++)
				this.pushBack(array[i]);
		}

		/**
		* Creates a new container with data from a vector.
		* Params:
		*	vector =			Vector with data to be added.
		*/
		this(ref Vector vector)
		{
			this();

			for(int i = 0; i < vector.length; i++)
				this.pushBack(vector[i]);
		}

		~this()
		{
			clear();
		}

		/**
		* Pushes the element to the back of container.
		* Params:
		*	element =			Element to be pushed.
		*/
		void pushBack(T element)
		{
			_container.length++;
			_container[_container.length-1] = element;
		}

		/**
		* Pushes the element to the front of container.
		* Params:
		*	element =			Element to be pushed.
		*/
		void pushFront(T element)
		{
			_container.length++;

			// move every element by one to the back
			for(int i = _container.length-1; i > 0; i--)
				_container[i] = _container[i-1];

			_container[0] = element;
		}

		/**
		* Removes the element at specified index.
		* Params:
		*	index =				Index of element to be removed.
		*/
		void remove(int index)
		{
			// just move everything by one to the front from this position
			for(int i = index; i < _container.length-1; i++)
				_container[i] = _container[i+1];

			_container.length--;
		}

		ref T opIndex(int index)
		{
			return _container[index];
		}

		void opIndexAssign(T value, int index)
		{
			_container[index] = value;
		}

		/**
		* Pops the element from the back of container.
		* Returns: Popped element.
		*/
		T popBack()
		{
			T temp = _container[_container.length-1];

			remove(_container.length-1);

			return temp;
		}

		/**
		* Pops the element from the front of container.
		* Returns: Popped element.
		*/
		T popFront()
		{
			T temp = _container[0];

			remove(0);

			return temp;
		}

		/// Clears the container.
		void clear()
		{
			_container.length = 0;
		}

		/**
		* Sorts the container using custom comparison function.
		* Params:
		*	comp =				Reference to the boolean function implementing proper comparison functionality.
		*						E.g. for T = int, referencing this function: bool cmp(int a, int b) { return a > b; }
		*						will sort the container in descending order.
		*/
		void sort(U)(U comp)
		{
			std.algorithm.sort!(comp)(_container);
		}

		/*
		/ // Sorts the container in ascending order using the default "<" implementation for T type.
		// commented out until compiler stops bitching about no opCmp for SDL_Event in Palaio.Input.
		void sort()
		{
			std.algorithm.sort(_container);
		}*/

		/// Gets the length of the container.
		@property int length() { return _container.length; }
}
