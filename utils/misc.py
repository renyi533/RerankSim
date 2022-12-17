import tensorflow.compat.v1  as tf

def create_session(graph=None):
    physical_devices = tf.config.experimental.list_physical_devices('GPU') 
    print('GPU devices:')
    print(physical_devices)
    for device in physical_devices:
        tf.config.experimental.set_memory_growth(device, True)
    config = tf.ConfigProto()
    config.gpu_options.allow_growth = True
    config.allow_soft_placement = True
    if graph is None:
        return tf.Session(config=config)
    else:
        return tf.Session(graph=graph, config=config)