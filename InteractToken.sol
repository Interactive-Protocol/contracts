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
