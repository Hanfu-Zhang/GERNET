from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField, SubmitField, IntegerField
from wtforms.validators import DataRequired
from flask_wtf.file import FileField, FileRequired, FileAllowed


class UploadDataForm(FlaskForm):
    file = FileField('请选择.dat文件', validators=[FileRequired(), FileAllowed(['dat'])])
    label = IntegerField("数据标签", validators=[DataRequired()])
    submit = SubmitField('上传')


class TestForm(FlaskForm):
    file = FileField('请选择.dat文件', validators=[FileRequired(), FileAllowed(['dat'])])
    submit = SubmitField('测试')