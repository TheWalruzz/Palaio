module Palaio.Utilities.Node;

import Palaio.Utilities.Vector;

/// Class implementing the tree node.
class Node(T)
{
    private:
        T _data;
        Node _parent;
        Vector!Node _children;

    public:
		/// Creates empty node.
        this()
        {
            _parent=null;
            _children=new Vector!Node();
        }

		/**
		* Creates a new node with a parent.
		* Params:
		*	parent =		Reference to the parent node.
		*/
        this(ref Node parent)
        {
            this();
            _parent=parent;
        }

		/**
		* Creates a new node with a parent and data.
		* Params:
		*	parent =		Reference to the parent node.
		*	data =			Data to be added.
		*/
        this(ref Node parent,ref T data)
        {
            this(parent);
            _data=data;
        }

		/**
		* Creates a new node without a parent and with data.
		* Params:
		*	data =			Data to be added.
		*/
        this(T data)
        {
            this();
            _data=data;
        }

		/**
		* Adds a child to the node.
		* Params:
		*	child =			Reference to the child node.
		*/
        void addChild(ref Node child)
        {
            child.parent=this;
            _children.pushBack(child);
        }

		/**
		* Adds a new child to the node with new data.
		* Params:
		*	data =			Data to be added.
		*/
        void addChild(ref T data)
        {
            Node child=new Node(this,data);
            _children.pushBack(child);
        }

		/**
		* Gets a child.
		* Params:
		*	i =				Index of a child.
		* Returns: Reference to the child node.
		*/
        ref Node getChild(int i)
        {
            return _children[i];
        }

        ref Node opIndex(int i)
        {
            return _children[i];
        }

        void opIndexAssign(ref Node value, int i)
        {
            _children[i]=value;
        }

		/**
		* Removes a child.
		* Params:
		*	i =				Index of child to be removed.
		*/
        void removeChild(int i)
        {
            _children.remove(i);
        }

		/// Removes all the children.
        void removeChildren()
        {
            _children.clear();
        }

		/// Sorts the children in ascending order using standard "<" implementation for T template type.
		void sortChildren()
		{
			_children.sort();
		}

		@property
		{
			/// Gets a vector of children.
			ref Vector!Node children() { return _children; }

			/// Gets a reference to the parent.
			ref Node parent() { return _parent; }

			/// Gets the data stored.
			ref T data() { return _data; }

			/// Gets the number of children.
			int childrenSize() { return _children.length; }

			/// Checks if node is a leaf (has no children).
			bool isLeaf() { return (_children.length==0); }
		}
}
