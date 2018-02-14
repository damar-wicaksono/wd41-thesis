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

.. Goal of simulation and entry to safety analysis

Scientific codes play a central role in deterministic safety analysis of nuclear power plants (NPPs).
They provide a *physics-based* evaluation of relevant phenomena taking place in the plant during postulated transients to demonstrate that safety requirements are met :cite:`IAEA2009`.
The demonstration is carried out with respect to acceptance criteria, a set of limits and conditions ensuring the integrity of the safety barriers.
The criteria are set by regulatory bodies for normal and off-normal operation of the plants.

.. Deterministic safety analysis

The physics-based evaluation is achieved through simulation.
As noted in :cite:`IAEA2009,DAuria2012`, there are four disciplines associated with the different physical processes relevant in the safety analysis of the plant behavior:
the *neutronics* of the core;
the *thermo-mechanics* of the fuel and reactor components;
the *radiological* analysis of a possible release;
and, the *system thermal-hydraulics* of the plant, the subject of this thesis [*]_.
Each discipline is, in turn, characterized by a distinct set of governing physical equations and that are often solved by a distinct code.

.. Entry to Conservative vs Best Estimate

The :term:`NPP` safety is established, among other things, by setting the acceptance criteria in terms of limiting physical quantities relevant for the phenomena involved.
The upper tolerance limit of :math:`1'204\,[^oC]` for the peak clad temperature (:term:`PCT`) is one such criteria for light water reactors (:term:`LWR`) :cite:`USNRC2017`.
Whether the physical quantities respect such limits during postulated scenarios is analyzed using simulations either in a conservative or best-estimate approach :cite:`IAEA2009`.

.. Conservative Analysis

During its early days, reactor safety analysis involved a high-degree of conservatism.
Conservatism called for the most pessimistic and penalizing modeling assumptions (including initial and boundary conditions) to ensure conservative results, that is far below their expected values.
This approach, was justified by limited modeling capabilities and limited knowledge of the physical process involved.
However, it was later found that there are conditions for which conservative assumptions do not lead to conservative (or even physical) predictions.

.. An Illustration

As an example, consider the analysis for a :term:`LOCA` of an :term:`LWR`.
Assuming less interfacial shear between the liquid and the gas phases of the coolant (water) reduces mist flow and is a conservative assumption because less heat is transferred to the coolant flow in the upper region of the core, which penalizes the fuel temperature prediction.
But this assumption also reduces that the time to refill the core as more liquid is retained in the reactor cooling system.
Furthermore, with less shear, there is less resistance in injecting emergency coolant into the core (condition known as the counter-current flow limitation).
Both effects are clearly not conservative and put into question the conservatism of the prediction :cite:`IAEA2009`.

.. Best-estimate Analysis

Because of this example and many others :cite:`IAEA2009`, a more accurate prediction of two-phase flow transient behavior under accident conditions was deemed necessary.
As opposed to the conservative approach, *best-estimate* approach calls for (more) physically sound thermal-hydraulics models with more realistic assumptions, which are backed up by experimental data obtained from numerous experimental programs conducted in Separate and Integral Effect Test Facilities.
In that context, Best-estimate :term:`TH` system codes were developed to provide more realistic predictions.
The codes were designed to be comprehensive tools capable of simulating realistically a wide range of transients foreseen in :term:`LWR` operation,
and were developed using the current best understanding of flow processes expected to happen during the transients.

Thermal-Hydraulics (TH) System Codes
------------------------------------

.. [*] Ref. :cite:`DAuria2012` added one additional key discipline, namely: *reliability analysis*. It is excluded in the above listing as it is not technically a discipline of *physics*.

