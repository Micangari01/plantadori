import sys
import os
from PyQt5.QtWidgets import QApplication, QWidget, QLabel, QVBoxLayout, QHBoxLayout, QPushButton, QFileDialog, QLineEdit, QInputDialog
from subprocess import call

class PlantadoriGUI(QWidget):
    def __init__(self):
        super().__init__()

        self.setWindowTitle('Plantadori - Criação de LiveUSB')
        self.layout = QVBoxLayout()

        self.label = QLabel('Selecione a opção:')
        self.layout.addWidget(self.label)

        self.button_micangarios = QPushButton('MiçangáriOS')
        self.button_micangarios.clicked.connect(self.create_micangarios_liveusb)
        self.layout.addWidget(self.button_micangarios)

        self.button_custom = QPushButton('Personalizado')
        self.button_custom.clicked.connect(self.create_custom_liveusb)
        self.layout.addWidget(self.button_custom)

        self.setLayout(self.layout)

    def create_micangarios_liveusb(self):
        output_file_dialog = QFileDialog()
        output_file_path, _ = output_file_dialog.getSaveFileName(self, 'Salvar imagem ISO', '', 'Imagens ISO (*.iso)')

        if output_file_path:
            os.system('git clone https://github.com/Micangari01/plantadori.git')
            os.chdir('plantadori')
            os.system('./plantadori.sh')
            os.system(f'genisoimage -o {output_file_path} plantadori.sh')
            os.chdir('..')
            os.system('rm -rf plantadori')

            self.label.setText('Imagem ISO criada com sucesso!')

            self.format_liveusb(output_file_path)

    def create_custom_liveusb(self):
        output_file_dialog = QFileDialog()
        output_file_path, _ = output_file_dialog.getSaveFileName(self, 'Salvar imagem ISO', '', 'Imagens ISO (*.iso)')

        if output_file_path:
            repo_dialog = QInputDialog()
            repo_dialog.setWindowTitle('Repositório Git Personalizado')
            repo_dialog.setLabelText('Digite o endereço do repositório Git:')
            repo_dialog.setInputMode(QInputDialog.TextInput)

            if repo_dialog.exec_():
                repo_address = repo_dialog.textValue()
                os.system(f'git clone {repo_address}')
                repo_name = os.path.basename(repo_address).split('.git')[0]
                os.chdir(repo_name)
                os.system('./plantadori.sh')
                os.system(f'genisoimage -o {output_file_path} plantadori.sh')
                os.chdir('..')
                os.system(f'rm -rf {repo_name}')

                self.label.setText('Imagem ISO criada com sucesso!')

                self.format_liveusb(output_file_path)

    def format_liveusb(self, iso_file_path):
        pendrive_dialog = QFileDialog()
        pendrive_path, _ = pendrive_dialog.getOpenFileName(self, 'Selecionar pendrive', '', 'Dispositivos USB (*usb*)')

        if pendrive_path:
            persistence_size_dialog = QInputDialog()
            persistence_size_dialog.setWindowTitle('Tamanho do Armazenamento Persistente')
            persistence_size_dialog.setLabelText('Digite o tamanho do armazenamento persistente em MB:')
            persistence_size_dialog.setInputMode(QInputDialog.IntInput)
            persistence_size_dialog.setIntMinimum(1)
            persistence_size_dialog.setIntMaximum(32768)

            if persistence_size_dialog.exec_():
                persistence_size = persistence_size_dialog.intValue()
                persistence_size_mb = persistence_size * 1024

                command = f'sudo dd bs=4M if={iso_file_path} of={pendrive_path} status=progress && sudo parted {pendrive_path} --script mklabel msdos mkpart primary fat32 1MiB {persistence_size_mb}MiB mkpart primary ext4 {persistence_size_mb + 1}MiB 100% set 1 boot on'
                call(command, shell=True)

                self.label.setText('LiveUSB criado com sucesso!')
                self.button_micangarios.setEnabled(False)
                self.button_custom.setEnabled(False)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    gui = PlantadoriGUI()
    gui.show()
    sys.exit(app.exec_())
