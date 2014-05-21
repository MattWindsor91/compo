# Compo

**Compo** is a library providing mixins and base classes for setting up
composite objects.

It's similar to the Gang of Four Composite pattern, but in Compo
children are identified in their parents by an *ID*,
such as an index or hash key, that the child is aware of at all times.

Compo was designed for models whose composite
structure can be expressed as URLs made from their recursive ID trails.

## Installation

Add this line to your application's Gemfile:

    gem 'compo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install compo

## Usage

Compo consists of several classes and mixins that implement various parts of the composite pattern.  In increasing order of general usefulness, they are:

### Base mixins

- **Composite**, which specifies the #add/#remove/#remove_id/#get_child API on top of an implementation;
- **Movable**, which creates a #move_to method that simplifies the act of moving a child between Composites;
- **ParentTracker**, which implements keeping track of a child's parent and the child end of #add/#remove;
- **URLReferenceable**, which allows the current position of an object in a hierarchy of composites to be retrieved as an URL-style reference;
- **Branch**, which is simply a **Moveable** **URLReferenceable** **ParentTracker**.

### Composite implementation classes

These implement the methods needed for **Composite** to work, but don't implement moving, parent tracking, or anything else.

- **ArrayComposite**, which is a class that implements **Composite** using an Array, with IDs being the array indices;
- **HashComposite**, which is a class that implements **Composite** using a Hash, with IDs being the hash keys;
- **NullComposite**, which allows no children but implements **Composite** in a way such that all operations fail;

### Simple leaf and node classes

These include **Branch**, and thus can be moved around, added to and removed from composites, and track their current parents and IDs.

- **Leaf**, which is based on NullComposite and is intended for objects that don't have children but can be placed in other Composites;
- **ArrayBranch**, which is based on ArrayComposite;
- **HashBranch**, which is based on HashComposite.

Generally, you'll only need to use these classes (use **Leaf** when creating objects that can be part of other objects but not have children themselves, **ArrayBranch** when an object has a list of ordered children *whose ordering changes as more children are added and deleted*, and **HashBranch** when it has a collection of children with arbitrary IDs).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
