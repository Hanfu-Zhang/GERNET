from . import db


class Feature(db.Model):
    __tablename__ = 'Feature'

    id = db.Column(db.String(40), primary_key=True, index=True, unique=True)
    feature = db.Column(db.Text)
    label = db.Column(db.Integer)