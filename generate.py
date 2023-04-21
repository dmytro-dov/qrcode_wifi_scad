import qrcode
import sys
import os

def generate_qr_code(text):
    qr = qrcode.QRCode(
        version=None,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=1,
        border=0,
    )
    qr.add_data(text)
    qr.make(fit=True)
    matrix = qr.get_matrix()
    qr_list = [[int(bit) for bit in row] for row in matrix]
    return qr_list

if __name__ == '__main__':
    if len(sys.argv) == 2:
        if not os.path.exists("./output"):
            os.makedirs("./output")
        text = sys.argv[1]
        qr_list = generate_qr_code(text)
        with open("./qrcode-matrix.scad", 'w') as f:
            f.write('qrData = ')
            f.write(str(qr_list) + ';')
        # Provide a path to openscad executable. Leave unchanged if openscad can be found in PATH variable (openscad can be run as a command from shell).
        openscad_path='openscad'
        os.system(openscad_path + ' ./wifi-card.scad -D qrCodeOnly=true -o ./output/qrcode.stl')
        os.system(openscad_path + ' ./wifi-card.scad -D qrCodeOnly=false -D nfcTag=true -o ./output/main_body.stl')
    else:
        print('Error: Please provide a string to encode.')

