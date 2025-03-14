

class InputManager {
public:
    void Update();
    bool KeyIsPressed(int keyVal);
    void SetWindow(GLFWwindow* newWindow);

    GLFWwindow* thisWindow;
};