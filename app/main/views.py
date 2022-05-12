from flask import render_template, flash, redirect, url_for
from .forms import UploadDataForm, TestForm
from . import main
import uuid
import random
import matlab.engine
from ..models import Feature
from .. import db
import json
import time


def generate_uuid():
    return str(uuid.uuid5(uuid.NAMESPACE_DNS, str(uuid.uuid1()) + str(random.random())))


@main.route('/', methods=['GET', 'POST'])
def home():
    return redirect(url_for('.database'))


@main.route('/database', methods=['GET', 'POST'])
def database():
    form = UploadDataForm()
    if form.validate_on_submit():
        file = form.file.data
        label = form.label.data
        filename = generate_uuid() + ".dat"
        file.save("app/code/test-data/" + filename)
        engine = matlab.engine.start_matlab()
        engine.cd("app/code/", nargout=1)
        feature = engine.FS("test-data/" + filename)
        new_feature = Feature(id=generate_uuid(), feature=str(feature), label=label)
        db.session.add(new_feature)
        db.session.commit()
        flash("上传成功！")
        return redirect(url_for('.database'))
    features = Feature.query.order_by(Feature.label.asc()).all()
    return render_template("database.html", form=form, features=features)


@main.route('/delete-feature/<id>', methods=['GET', 'POST'])
def delete_feature(id):
    feature = Feature.query.filter_by(id=id).first_or_404()
    db.session.delete(feature)
    db.session.commit()
    return redirect(url_for('.database'))


@main.route('/test-database', methods=['GET', 'POST'])
def test_database():
    form = TestForm()
    feature = ""
    judge_res = ""
    test_duration = ""
    if form.validate_on_submit():
        if Feature.query.count() == 0:
            flash("请先录入指纹数据！")
            return redirect(url_for(".database"))
        # 1、存储上传的.dat文件
        file = form.file.data
        filename = generate_uuid() + ".dat"
        dat_file_path = "test-data/" + filename
        file.save("app/code/" + dat_file_path)

        # 2、启动Matlab引擎
        engine = matlab.engine.start_matlab()
        engine.cd("app/code/", nargout=1)

        # 3、获得指纹库，并生成指纹库的.mat文件
        features = Feature.query.all()
        featureMatrix = "["
        for feature in features:
            f = eval(feature.feature)[0]
            for item in f:
                featureMatrix += str(item) + " "
            featureMatrix += str(feature.label)
            featureMatrix += ";"
        featureMatrix = featureMatrix[0: -1] + "]"
        filename = generate_uuid() + ".mat"
        mat_file_path = "mats/" + filename
        matlabCode = "finger_database = " + str(featureMatrix) + "; save(\"" + mat_file_path + "\", \"finger_database\");"
        tic = time.time()
        engine.eval(matlabCode, nargout=0)
        toc = time.time()
        test_duration = str(toc - tic).split('.')[0] + "." + str(toc - tic).split('.')[1][0: 2] + "s"
        # 4、拿到特征
        feature = engine.FS(dat_file_path)

        # 5、判断设备合法性
        judge_res = engine.Test(dat_file_path, mat_file_path, nargout=1)

        # 6、停止引擎
        engine.quit()
    return render_template("test_database.html", form=form, feature=feature, judge_res=judge_res, test_duration=test_duration)


@main.route('/test-model', methods=['GET', 'POST'])
def test_model():
    form = UploadDataForm()
    classification = -1
    if form.validate_on_submit():
        file = form.file.data
        filename = generate_uuid() + ".dat"
        file.save("app/code/test-data/" + filename)
        engine = matlab.engine.start_matlab()
        engine.cd("app/code/", nargout=1)
        classification = int(engine.FS_C("test-data/" + filename))
        engine.quit()
        flash("上传成功！")
    return render_template("test_model.html", form=form, classification=classification)


@main.route('/test', methods=['GET', 'POST'])
def test():
    features = Feature.query.all()
    featureMatrix = "["
    for feature in features:
        f = eval(feature.feature)[0]
        for item in f:
            featureMatrix += str(item) + " "
        featureMatrix += str(feature.label)
        featureMatrix += ";"
    featureMatrix = featureMatrix[0: -1] + "]"
    engine = matlab.engine.start_matlab()
    filename = generate_uuid() + ".mat"
    engine.cd("app/code/", nargout=1)
    matlabCode = "finger_database = " + str(featureMatrix) + "; save(\"mats/" + filename + "\", \"finger_database\");"
    engine.eval(matlabCode, nargout=0)
    engine.quit()
    return json.dumps(featureMatrix)
