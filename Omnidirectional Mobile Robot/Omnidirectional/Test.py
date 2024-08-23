import pybullet as p
import pybullet_data
omni_id = p.connect(p.GUI)
p.setGravity(0, 0, -9.81, physicsClientId = omni_id)
p.setAdditionalSearchPath(pybullet_data.getDataPath())
Omni = p.loadURDF("Robot.urdf", basePosition = [0, 0, 0.2])
Plane = p.loadURDF("Plane.urdf")
position, orientation = p.getBasePositionAndOrientation(Omni)
print(position, orientation)
number_of_joints = p.getNumJoints(Omni)
while(1):
    p.setJointMotorControl2(Omni, 1,
                                p.VELOCITY_CONTROL,
                                targetVelocity = -5,
                                force = 1.9)
    p.setJointMotorControl2(Omni, 3,
                                p.VELOCITY_CONTROL,
                                targetVelocity = 5,
                                force = 1.9)
    p.setJointMotorControl2(Omni, 5,
                                p.VELOCITY_CONTROL,
                                targetVelocity = 5,
                                force = 1.9)
    p.setJointMotorControl2(Omni, 7,
                                p.VELOCITY_CONTROL,
                                targetVelocity = -5,
                                force = 1.9)
    p.stepSimulation()
    p.setRealTimeSimulation(0)