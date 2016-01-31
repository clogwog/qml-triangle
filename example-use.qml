import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1


Item {

    visible: true
    id: app
    width: 320; height: 480

    signal startFlickrSettings()
    signal unlinkFlickr();

    Action {
        id: goBack
        onTriggered: {
            pageStack.pop()

            console.log("action goback : " + pageStack.currentItem.objectName)

            if ( pageStack.currentItem.objectName === "PhotoGrid")
            {
                if ( !flickrModel.linked && !flickrModel.loading )
                    pageStack.pop()
            }
        }
    }

    Action {
        id: settingsPressed
        onTriggered: {
            console.log("pressed settings for: " + pageStack.currentItem.objectName)
            if ( pageStack.currentItem.objectName === "PhotoGrid")
            {
                loadComponent("qrc:///pages/FlickrSettings.qml", "FlickrSettings")
            }
        }
    }


    function loginToFlickr(loadUrl)
    {
        pageStack.currentItem.theUrl = loadUrl
    }
    function closeBrowser()
    {
        goBack.trigger()
    }

    function loadComponent(component, name)
    {
        pageStack.push({item:component,properties:{objectName:name}});
    }
    function isLoadedInStack(name)
    {
        return (pageStack.currentItem && pageStack.currentItem.objectName === name)
    }


    Rectangle
    {
        anchors.fill: parent
        color: "#00000000"

        StackView
        {
            id: pageStack
            initialItem: "qrc:///pages/graph.qml"

            anchors
            {
                top: parent.top
                bottom: toolBar.top
            }
        }

        // Toolbar ---------------------------------
        Rectangle
        {

            id: toolBar
            height: 60
            anchors.bottom: parent.bottom
            width: parent.width

            color: "#1a1919"

            Triangle {
                        id: backButton
                        x: 0
                        y: 0
                        height: parent.height
                        width: height
                        triangleWidth: 30
                        triangleHeight: 30
                        onClicked: goBack.trigger()
                        visible: isLoadedInStack("Details") || isLoadedInStack("PhotoGrid" ) || isLoadedInStack("FlickrSettings" )
            }

            Image {
                    id: settingsButton
                    x: toolBar.width - width
                    y: 10
                    sourceSize.width: backButton.width - 20
                    sourceSize.height: backButton.height- 20
                    source: 'img/settings.png'
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        id: settingsMouseArea
                        anchors.fill: parent
                        onClicked: settingsPressed.trigger()
                    }
                    visible: ( pageStack.currentItem && pageStack.currentItem.objectName === "PhotoGrid")
            }

        }
        // ---- End Toolbar -------------------------
    }
}
