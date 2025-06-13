from flask import Blueprint, request, jsonify, abort
from app.models.schemas import ItemSchema

api_blueprint = Blueprint('api', __name__)

@api_blueprint.route('/items/', methods=['POST'])
def create_item():
    data = request.get_json()
    errors = ItemSchema().validate(data)
    if errors:
        return jsonify(errors), 400
    
    # Здесь может быть логика сохранения в БД
    return jsonify({'id': 1, **data}), 201

@api_blueprint.route('/items/<int:item_id>', methods=['GET'])
def get_item(item_id):
    if item_id == 42:
        abort(404, description="Item not found")
    return jsonify({'item_id': item_id})
