local object = script.Parent;

-- Though it is not needed, using WaitForChild instead of indexing directly is good practice.
local linearVelocity = object:WaitForChild("LinearVelocity");

-- https://en.wikipedia.org/wiki/Reflection_(mathematics)
local ReflectVector = function(direction: Vector3, normal: Vector3): Vector3
	normal = normal.Unit;
	local dotProduct = direction:Dot(normal);
	return direction - 2 * dotProduct * normal;
end


local TouchedEventListener = function(otherPart: Part)
	-- Create raycast params object
	local raycastParams = RaycastParams.new();
	-- The only parts that will be checked with the raycast will be otherPart and its children
	raycastParams.FilterDescendantsInstances = {otherPart};
	raycastParams.FilterType = Enum.RaycastFilterType.Include;
	
	-- Find where and what direction the raycast will be and go
	local raycastOrigin = object.Position;
	local raycastDirection = linearVelocity.VectorVelocity.Unit * object.Size.Magnitude;
	
	-- Cast the ray
	local raycastResult = workspace:Raycast(raycastOrigin, raycastDirection, raycastParams);
	
	-- Return if nil to prevent errors
	if (raycastResult == nil) then 
		return;
	end
	
	-- Find reflected vector based on the normal the ray intersected with
	local reflectedVector = ReflectVector(linearVelocity.VectorVelocity.Unit, raycastResult.Normal);
	-- Find the magnitude (speed) of the velocity
	local magnitude = linearVelocity.VectorVelocity.Magnitude;
	-- Find reflected velocity
	local reflectedVelocity = magnitude * reflectedVector.Unit;
	
	-- Apply reflected velocity to linearVelocity and object
	linearVelocity.VectorVelocity = reflectedVelocity;
	object.AssemblyLinearVelocity = reflectedVelocity;
	
end
-- Connect TouchEventListener to .Touch event
object.Touched:Connect(TouchedEventListener);