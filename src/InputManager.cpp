#define GLFW_INCLUDE_NONE
#include "GLFW/glfw3.h"

#include "InputManager.h"

void InputManager::Update() {
	glfwPollEvents();
}

bool InputManager::KeyIsPressed(int keyVal) {
	if (glfwGetKey(thisWindow, keyVal) == GLFW_PRESS) {
		return true;
	}
	return false;
}

void InputManager::SetWindow(GLFWwindow* newWindow) {
	thisWindow = newWindow;
}