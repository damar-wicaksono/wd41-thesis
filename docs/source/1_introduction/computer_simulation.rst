.. _intro_computer_simulation:

Computer Simulation and Safety Analysis of Nuclear Power Plant
==============================================================

Scientific Computer Simulation
------------------------------

.. A definition

The ubiquity of computer simulation in science and engineering has resulted in numerous definitions of the term *scientific computer simulation*, *model*, and *simulation*.
To avoid confusion, this thesis adopts a recent definition proposed by Kaizer et al. :cite:`Kaizer2015` quoted below:

.. epigraph::

   Scientific Computer Simulation is the imitation of a behavior of a system, entity, phenomenon, or process in the physical universe 
   using limited mathematical concepts, symbols, and relations through the exercise or use of scientific computer model.
	
.. The definition, explained

This definition highlights three main points.
First, this definition accentuates the difference between *model* and *simulation*.
A model deals with the notion of representation of a system, while a simulation deals with the notion of imitation of a behavior of that system.
Secondly, a model is said to be scientific when it represents a real world system as its subject.
Finally, the modifier *computer* generally implies that the mathematical models cannot be solved analytically and their solutions require a computer.
Because the associated numerical approximations can affect its solution, many computational-related aspects often need to be considered.
This thesis only deals with computer simulation.

.. A distinction by Beven

Beven :cite:`Beven2009` articulates this definition of a scientific model further through the following distinctions: a perceptual model (i.e., the theoretical description of the physical phenomena),
a formal model (i.e., its mathematical description),
and a procedural model (i.e., the computer implementation of the formal model).
For many physical models of complex system, only the procedural model is able to make a quantitative prediction of the system behavior.
These distinctions are useful in acknowledging the level of approximation involved in modeling.

.. Code

A computer software that implements scientific models down to the solution algorithms is called a *scientific code* or simply a *code* :cite:`Trucano2006`.
Many modern implementations of scientific codes, apart from possibly being specific to a scientific domain, are comprehensive platforms.
For instance, in the context of thermal-hydraulics (:term:`TH`) system modeling, such codes allow modeling various attributes of the system ranging from its geometry, initial and boundary conditions, and design variables to the settings for discretization scheme and numerical solver.

.. Simulator

A *simulation* or a *calculation* :cite:`Trucano2006` using a code can only be made on a particular well-specified system, where all the aforementioned attributes (geometry, initial and boundary conditions, etc.) have been completely fixed or specified.
As a result, the terms *computer simulation model* or *simulator* include not only the code itself, but also the particular system of interest being modeled using the code :cite:`OHagan2006`.

Codes and Safety Analysis of Nuclear Power Plant
------------------------------------------------

Thermal-Hydraulics (TH) System Codes
------------------------------------

