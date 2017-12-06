# A minimal Inkling program for a BRAIN that learns how to operate climate
# control using BCVTB and EnergyPlus.

# A schema defining the dictionary returned from the Python simulation's
# advance method to the BRAIN
schema SimState
    Int32{0:10} SolarIrradiation
end

# This schema defines the 'actions', a dictionary of control signals this AI
# can send to the climate control
# shade == night, off, day
schema SimAction
    Int32 {0, 1} shade
end

# This schema defines the dictionary passed as a parameter to the 
# set_properties method of the Python simulator
schema SimConfig
    Int32{-1} unused
end

# The simulator clause declares that a simulator named "energyplus_simulator"
# will be connecting to the server for training.
# The following statements bind the above schemas to this simulator
simulator energyplus_simulator(SimConfig)
    action (SimAction)
    state (SimState)
end

# An example concept that predicts a SimAction given a SimState
# In this simple demo we just ask the Bonsai Platform to generate any model
# that can learn to control the server using these inputs and outputs
concept my_concept is classifier
   predicts (SimAction)
   follows input(SimState)
   feeds output
end

# This curriculum will train the Bonsai Platform generated model until it can
# reach a maximum value of 'reward_function'. A function defined in the 
# energyplus_simulator
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
