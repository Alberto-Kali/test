from fastapi import APIRouter, HTTPException
from app.models.schemas import ItemCreate, ItemResponse

router = APIRouter()

@router.post("/items/", response_model=ItemResponse)
async def create_item(item: ItemCreate):
    """Создание нового item"""
    # Здесь может быть логика сохранения в БД
    return {"id": 1, **item.dict()}

@router.get("/items/{item_id}")
async def read_item(item_id: int):
    if item_id == 42:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"item_id": item_id}
