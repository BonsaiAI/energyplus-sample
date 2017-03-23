# A minimal Inkling program for a BRAIN that learns how to play a simulation or
# game.

# A schema defining the dictionary returned from the Python simulation's
# advance method to the BRAIN
#    Double TOut,
#    Double TZone,
#    Double SolarIrradiation
#    Double FractionShadingOn

schema SimState
    Int32{0:10} SolarIrradiation
end

# This schema defines the 'actions' dictionary passed as a parameter to the
# advance method of the Python simulator
# shade == night, off, day
schema SimAction
#    Double {0, 6} shade
    Int32 {0, 1} shade
end

# This schema defines the dictionary passed as a parameter to the 
# set_properties method of the Python simulator
schema SimConfig
    Int32{-1} unused
end

# This simulator is the training source for teaching my_concept. The Python
# simulator identifies itself as 'my_simulator' when it connects with the
# AI Engine. The following statements bind the above schemas to this simulator
simulator energyplus_simulator(SimConfig)
    action (SimAction)
    state (SimState)
end

# An example concept that predicts a SimAction given a SimState
concept my_concept is classifier
   predicts (SimAction)
   follows input(SimState)
   feeds output
end

# my_curriculum trains my_concept using my_simulator. The first lesson
# has the BRAIN "play" my_simulator. The BRAIN will try to maximize the value
# returned from time_at_goal until you stop training. time_at_goal is a
# method on the Python simulator.
curriculum my_curriculum
    train my_concept
    with simulator energyplus_simulator
    objective reward_function
        lesson my_first_lesson
            configure
                constrain unused with Int32{-1}
            until
                maximize reward_function
end