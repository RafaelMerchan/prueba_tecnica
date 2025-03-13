from fastapi import APIRouter
from dtb import get_dtb

router = APIRouter()

@router.post("/api/tasks")
def create_task(task: Task):
    conectar, cursor = get_dtb()
    cursor.execute("INSERT INTO tasks (title, description, status) VALUES (?, ?, ?)", (task.title, task.description, task.status))
    conectar.commit()
    return {"message":"Task creado exitosamente"}

@router.get("/api/tasks")
def get_tasks():
    conectar, cursor = get_dtb()
    cursor.execute("SELECT id, title, description, status FROM tasks")
    tasks = cursor.fetchall()
    return [{"id": t[0], "title": t[1], "description": t[2], "status":t[3]} for t in tasks]

@router.get("/api/tasks/{id_task}")
def get_task(id_task: int):
    conectar, cursor = get_dtb()
    cursor.execute("SELECT id, title, description, status FROM tasks WHERE id = ?", (id_task))
    task = cursor.fetchone()
    if task is None:
        return {"message": "Task no encontrado"}
    return {"id": task[0], "title": task[1], "description": task[2], "status": task[3]}

@router.put("/api/tasks/{id_task}")
def update_task(id_task: int, task_act: Task):
    conectar, cursor = get_dtb()
    cursor.execute("SELECT id, title, description, status FROM tasks WHERE id = ?", (id_task))
    if task is None:
        return {"message": "Task no encontrado"}
    cursor.execute("UPDATE tasks SET title = ?, description = ?, status = ? WHERE id = ?",(task_act.title, task_act.description, task_act.status, id_task))
    conectar.commit()
    return {"message": "Task actualizado exitosamente"}

@router.delete("/api/tasks/{id_task}")
def delete_task(id_task: int):
    conectar, cursor = get_dtb()
    cursor.execute("SELECT id, title, description, status FROM tasks WHERE id = ?", (id_task))
    if task is None:
        return {"message": "Task no encontrado"}
    cursor.execute("DELETE FROM tasks WHERE id = ?", (id_task))
    conectar.commit()
    return {"message": "Task eliminado exitosamente"}
