from marshmallow import Schema, fields

class ItemSchema(Schema):
    name = fields.Str(required=True)
    description = fields.Str()
    price = fields.Float(required=True)
