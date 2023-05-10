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
}
