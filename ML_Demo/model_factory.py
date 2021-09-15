import torch
import torchvision
def generate_model(min_size = 3200):
    min_size = 3200
    return torchvision.models.detection.fasterrcnn_resnet50_fpn(pretrained=True, min_size=min_size)