// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InteractiveProtocol {
    struct Task {
        uint256 taskId;
        address user;
        string script;
        uint256 bidAmount;
        address selectedNode;
        bool isCompleted;
        string result;
    }

    uint256 public taskId;
    mapping(uint256 => Task) public tasks;

    event TaskSubmitted(uint256 indexed taskId, address indexed user, string script);
    event TaskBid(uint256 indexed taskId, address indexed node, uint256 bidAmount);
    event TaskCompleted(uint256 indexed taskId, address indexed node, string result);

    function submitTask(string calldata _script) external {
        taskId++;
        Task storage newTask = tasks[taskId];
        newTask.taskId = taskId;
        newTask.user = msg.sender;
        newTask.script = _script;
        newTask.isCompleted = false;

        emit TaskSubmitted(taskId, msg.sender, _script);
    }

    function submitBid(uint256 _taskId, uint256 _bidAmount) external {
        Task storage existingTask = tasks[_taskId];
        require(existingTask.taskId == _taskId && !existingTask.isCompleted, "Invalid task ID or task already completed");

        existingTask.bidAmount = _bidAmount;
        existingTask.selectedNode = msg.sender;

        emit TaskBid(_taskId, msg.sender, _bidAmount);
    }

    function completeTask(uint256 _taskId, string calldata _result) external {
        Task storage existingTask = tasks[_taskId];
        require(existingTask.taskId == _taskId && !existingTask.isCompleted, "Invalid task ID or task already completed");

        existingTask.isCompleted = true;
        existingTask.result = _result;

        emit TaskCompleted(_taskId, msg.sender, _result);
    }

    function getTaskCount() external view returns (uint256) {
        return taskId;
    }

    function getTaskDetails(uint256 _taskId) external view returns (Task memory) {
        require(_taskId <= taskId, "Invalid task ID");

        return tasks[_taskId];
    }

    function isTaskCompleted(uint256 _taskId) external view returns (bool) {
        require(_taskId <= taskId, "Invalid task ID");

        return tasks[_taskId].isCompleted;
    }

    function getUserTasks() external view returns (uint256[] memory) {
        uint256[] memory userTaskIds = new uint256[](taskId);
        uint256 count = 0;

        for (uint256 i = 1; i <= taskId; i++) {
            if (tasks[i].user == msg.sender) {
                userTaskIds[count] = i;
                count++;
            }
        }

        uint256[] memory result = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = userTaskIds[i];
        }

        return result;
    }

    function getNodeTasks() external view returns (uint256[] memory) {
        uint256[] memory nodeTaskIds = new uint256[](taskId);
        uint256 count = 0;

        for (uint256 i = 1; i <= taskId; i++) {
            if (tasks[i].selectedNode == msg.sender) {
                nodeTaskIds[count] = i;
                count++;
            }
        }

        uint256[] memory result = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = nodeTaskIds[i];
        }

        return result;
    }

    function cancelTask(uint256 _taskId) external {
        Task storage existingTask = tasks[_taskId];
        require(existingTask.taskId == _taskId, "Invalid task ID");
        require(existingTask.user == msg.sender, "Only task owner can cancel the task");
        require(!existingTask.isCompleted, "Task has already been completed");

        delete tasks[_taskId];
    }

    function updateTaskResult(uint256 _taskId, string calldata _result) external {
        Task storage existingTask = tasks[_taskId];
        require(existingTask.taskId == _taskId, "Invalid task ID");
        require(existingTask.selectedNode == msg.sender, "Only selected node can update task result");
        require(existingTask.isCompleted, "Task has not been completed");

        existingTask.result = _result;
    }
