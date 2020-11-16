import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm
from sklearn.datasets.samples_generator import make_blobs

# Create plot function
def plot_classifier(X, y, model):
    # Plot data
    plt.scatter(X[:, 0], X[:, 1], c=y, s=50, cmap = 'cool')
    

    # Plot data with decision boundary
    ax = plt.gca()
    xlim = ax.get_xlim()
    ylim = ax.get_ylim()
    
    ## Create grid
    xx = np.linspace(xlim[0], xlim[1], 30)
    yy = np.linspace(ylim[0], ylim[1], 30)
    YY, XX = np.meshgrid(yy, xx)
    xy = np.vstack([XX.ravel(), YY.ravel()]).T
    
    Z = model.decision_function(xy).reshape(XX.shape)

    ## Plot decision boundary and margins
    ax.contour(XX, YY, Z, colors=['grey','red', 'grey'], levels=[-1, 0, 1], alpha=0.8,
               linestyles=['--', '-', '--'])

    ## Support vectors
    ax.scatter(model.support_vectors_[:, 0], model.support_vectors_[:, 1], s=100,
           linewidth=1, facecolors='none', edgecolors='grey')
    plt.show()


# Generate data
X, y = make_blobs(n_samples=100, centers=2,
                  random_state=123, cluster_std=3)

# Fit model 1
clf = svm.SVC(kernel='linear', C=0.1)
clf.fit(X, y)
plot_classifier(X, y, clf)

# Fit model 2
clf2 = svm.SVC(kernel='poly', C=0.1, degree=3)
clf2.fit(X, y)
plot_classifier(X, y, clf2)

# Fit model 3
clf3 = svm.SVC(kernel='rbf', C=0.1)
clf3.fit(X, y)
plot_classifier(X, y, clf3)

# Fit model 4
clf4 = svm.SVC(kernel='rbf', C=1)
clf4.fit(X, y)
plot_classifier(X, y, clf4)

