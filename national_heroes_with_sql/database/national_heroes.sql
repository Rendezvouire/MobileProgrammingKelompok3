
CREATE DATABASE IF NOT EXISTS national_heroes;

USE national_heroes;


-- create table heroes
CREATE TABLE IF NOT EXISTS heroes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    subtitle VARCHAR(255),
    image VARCHAR(255),
    origin VARCHAR(150),
    birth_death VARCHAR(50),
    biography TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);


-- create table comments

CREATE TABLE IF NOT EXISTS comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hero_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_comments_hero
        FOREIGN KEY (hero_id)
        REFERENCES heroes(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- insert data
INSERT INTO heroes
(
    name,
    full_name,
    subtitle,
    image,
    origin,
    birth_death,
    biography
)
VALUES

(
    'Jenderal Ahmad Yani',
    'Ahmad Yani',
    'Panglima Angkatan Darat & Pejuang Kemerdekaan',
    'assets/images/ahmad_yani.jpg',
    'Purworejo, Jawa Tengah',
    '1922 – 1965',
    'Jenderal TNI Anumerta Ahmad Yani merupakan salah satu tokoh militer berpengaruh dalam sejarah Indonesia yang pernah memegang posisi krusial sebagai Menteri/Panglima Angkatan Darat (Men/Pangad). Selama masa baktinya di TNI Angkatan Darat, beliau terlibat aktif dan memegang peran strategis dalam memimpin berbagai operasi militer penting untuk mempertahankan kedaulatan negara serta menumpas berbagai pemberontakan di tanah air pascakemerdekaan. Namun, pengabdian dan karier militernya harus terhenti secara tragis ketika beliau gugur pada 1 Oktober 1965 akibat menjadi salah satu korban penculikan dan pembunuhan dalam peristiwa Gerakan 30 September (G30S).'
),

(
    'Bung Tomo',
    'Sutomo',
    'Pengobar Semangat Perjuangan 10 November',
    'assets/images/bung_tomo.jpg',
    'Surabaya, Jawa Timur',
    '1920 – 1981',
    'Sutomo, yang lebih populer disapa Bung Tomo, merupakan figur sentral dalam sejarah perjuangan bangsa yang dikenang berkat kontribusi besarnya dalam membakar gelora semangat dan keberanian warga Surabaya. Menjelang hingga berlangsungnya Pertempuran 10 November 1945, beliau secara konsisten menyiarkan pidato-pidato orasi yang sangat membakar jiwa patriotisme melalui pemancar Radio Pemberontakan. Pekikan takbir dan narasi perlawanan yang dipancarkan lewat udara tersebut berhasil menyatukan serta menggerakkan seluruh lapisan masyarakat Surabaya untuk terus bertahan menghadapi gempuran pasukan sekutu demi mempertahankan kemerdekaan Republik Indonesia.'
),

(
    'Cut Nyak Dien',
    'Cut Nyak Dhien',
    'Pejuang Perempuan & Pemimpin Perlawanan Aceh',
    'assets/images/cut_nyak_dien.jpg',
    'Lampadang, Aceh',
    '1848 – 1908',
    'Cut Nyak Dien merupakan sosok pahlawan nasional wanita tangguh asal Aceh yang memegang peranan penting dalam perlawanan sengit melawan kolonialisme Belanda selama berlangsungnya Perang Aceh. Duka mendalam atas gugurnya sang suami, Teuku Umar, di medan pertempuran tidak menyurutkan gigihnya tekad perlawanan beliau. Tanpa gentar, Cut Nyak Dien mengambil alih kepemimpinan pasukan dan terus mengorbankan perang gerilya bergerak dari balik belantara pedalaman Aceh. Kendati usia lanjut, kondisi fisik yang kian melemah, serta penglihatan yang memburuk akhirnya membuat beliau tertangkap oleh pihak kolonial, Cut Nyak Dien kemudian diasingkan ke Sumedang, Jawa Barat, tempat beliau menghabiskan sisa hidupnya hingga wafat pada 6 November 1908.'
),

(
    'Cut Nyak Meutia',
    'Cut Nyak Meutia',
    'Pejuang Perempuan & Pemimpin Perlawanan Aceh',
    'assets/images/cut_nyak_meutia.jpg',
    'Keureutoe, Pirak, Aceh',
    '1870 – 1910',
    'Cut Nyak Meutia merupakan salah satu pahlawan nasional wanita pemberani asal Tanah Rencong, Aceh, yang mendedikasikan hidupnya untuk menumbangkan kekuasaan kolonial Belanda. Bersama pendamping hidupnya, beliau bahu-membahu menyusun strategi dan melancarkan serangkaian perlawanan sengit terhadap pasukan penjajah. Kehilangan sang suami yang gugur di medan laga tidak lantas mengikis kobaran semangat juangnya. Dengan kepemimpinan yang tangguh, Cut Nyak Meutia langsung mengambil alih komando pasukan dan terus membakar semangat perlawanan lewat taktik perang gerilya yang kerap menyulitkan musuh dari dalam hutan belantara. Pengabdian serta perjuangan gigih beliau akhirnya mencapai puncaknya ketika beliau gugur sebagai syahid dalam pertempuran sengit melawan pertempuran pasukan Belanda pada 24 Oktober 1910.'
),

(
    'Pangeran Diponegoro',
    'Pangeran Diponegoro',
    'Pemimpin Perang Jawa & Pejuang Kemerdekaan',
    'assets/images/diponegoro.jpg',
    'Yogyakarta',
    '1785 – 1855',
    'Pangeran Diponegoro merupakan sosok bangsawan sekaligus pahlawan nasional yang memimpin perlawanan bersenjata terhebat melawan pemerintah kolonial Hindia Belanda dalam pertempuran sengit yang dikenal sebagai Perang Jawa (1825–1830). Pergolakan skala besar ini menjadi salah satu episode konflik paling berdarah dan menguras sumber daya finansial maupun militer terbesar yang pernah dihadapi Belanda di Pulau Jawa. Setelah perlawanannya dipatahkan melalui taktik licik jebakan perundingan damai di Magelang pada 1830, beliau ditangkap dan dijatuhi hukuman pengasingan hingga akhirnya mengembuskan napas terakhir dalam penahanan di Makassar pada 8 Januari 1855.'
),

(
    'Dr. Sutomo',
    'Soebroto',
    'Pendiri Boedi Oetomo & Pelopor Pergerakan Nasional',
    'assets/images/dr_sutomo.jpg',
    'Nganjuk, Jawa Timur',
    '1888 – 1938',
    'Dr. Sutomo merupakan seorang dokter sekaligus pelopor pergerakan nasional yang memegang peranan sangat penting dalam sejarah perjuangan kemerdekaan melalui pendirian organisasi Boedi Oetomo pada tahun 1908. Kelahiran organisasi ini menjadi tonggak sejarah yang amat krusial karena menandai lahirnya era Kebangkitan Nasional serta menginspirasi terbentuknya berbagai pergerakan modern di seluruh pelosok Indonesia. Tidak berhenti pada profesi medis dan pembentukan Boedi Oetomo saja, Dr. Sutomo terus mencurahkan tenaga serta pikirannya secara aktif dalam berbagai pergerakan sosial, pendidikan, dan perjuangan politik nasional hingga akhir hayatnya.'
),

(
    'Tuanku Imam Bonjol',
    'Muhammad Shahab',
    'Pemimpin Perang Padri & Pejuang Sumatera Barat',
    'assets/images/imam_bonjol.jpg',
    'Bonjol, Sumatra Barat',
    '1772 – 1864',
    'Tuanku Imam Bonjol merupakan seorang ulama karismatik sekaligus pemimpin perlawanan yang gigih dalam kecamuk Perang Padri di Sumatera Barat. Beliau berdiri di garis terdepan menyatukan masyarakat untuk melawan penguasa kolonial Belanda yang berusaha menanamkan pengaruh politik dan ekonominya di wilayah Minangkabau. Setelah bertahun-tahun memimpin perlawanan sengit, beliau akhirnya ditangkap oleh pihak Belanda melalui taktik tipu muslihat perundingan, lalu dipindahkan ke beberapa tempat pengasingan hingga berakhir di wilayah Lotta, Pineleng, Minahasa, Sulawesi Utara. Beliau menghabiskan masa-masa terakhir hidupnya dalam pengasingan tersebut hingga wafat pada 6 November 1864.'
),

(
    'R.A. Kartini',
    'Raden Ajeng Kartini',
    'Pelopor Emansipasi Wanita & Kebangkitan Nasional',
    'assets/images/kartini.jpg',
    'Jepara, Jawa Tengah',
    '1879 – 1904',
    'Raden Ajeng Kartini merupakan figur pahlawan nasional yang dikenal luas sebagai pelopor emansipasi, kebangkitan, serta hak-hak pendidikan bagi kaum perempuan pribumi di Indonesia. Lahir dari lingkup bangsawan Jawa yang kental dengan tradisi feodal, beliau memanfaatkan privilese pendidikannya untuk mengamati serta mengkritik ketimpangan sosial dan keterbatasan akses pendidikan yang dialami kaum wanita pada masanya. Pemikiran-pemikiran progresif mengenai kesetaraan gender, kebebasan berpikir, dan pentingnya edukasi bagi kaum wanita banyak beliau tuangkan secara mendalam melalui korespondensi surat-surat kepada para sahabatnya di Belanda. Gagasan-gagasan visioner tersebut kelak dibukukan dan menjadi fondasi krusial yang menginspirasi lahirnya gerakan modernisasi serta perluasan akses pendidikan bagi perempuan di seluruh penjuru tanah air.'
),

(
    'Ki Hajar Dewantara',
    'Raden Mas Soewardi Soerjaningrat',
    'Bapak Pendidikan Nasional & Pelopor Pendidikan Rakyat',
    'assets/images/ki_hajar.jpg',
    'Yogyakarta',
    '1889 – 1959',
    'Ki Hajar Dewantara merupakan sosok pahlawan nasional yang diakui sebagai Bapak Pendidikan Nasional atas kontribusi terbesarnya mendirikan lembaga Perguruan Taman Siswa pada tahun 1922. Di tengah penindasan rezim kolonial Belanda yang membatasi hak belajar hanya untuk kalangan bangsawan, beliau gigih memperjuangkan akses pendidikan yang inklusif dan merata bagi rakyat pribumi biasa. Filosofi pendidikan serta prinsip kepemimpinan yang beliau cetuskan—termasuk semboyan legendaris Ing Ngarsa Sung Tuladha, Ing Madya Mangun Karsa, Tut Wuri Handayani—menjadi cikal bakal dan terus memberikan pengaruh fundamental yang mendalam terhadap arah perkembangan sistem pendidikan di Indonesia hingga saat ini.'
),

(
    'Martha Christina Tiahahu',
    'Martha Christina Tiahahu',
    'Pejuang Perempuan & Perlawanan Maluku',
    'assets/images/martha_tiahahu.jpg',
    'Nusa Laut, Maluku Tengah',
    '1800 – 1818',
    'Martha Christina Tiahahu merupakan srikandi gigih asal Maluku yang memegang peranan penting dalam panggung sejarah perjuangan kemerdekaan melalui perlawanan bersenjata melawan penjajahan Belanda pada tahun 1817. Menginjak usia yang sangat muda—yakni baru berumur 17 tahun—beliau sudah berdiri di garis terdepan mendampingi Kapitan Pattimura serta ayahnya sendiri untuk mengangkat senjata dan memimpin pasukan dalam serangkaian pertempuran sengit di wilayah Saparua dan sekitarnya. Meskipun pada akhirnya berhasil ditangkap oleh pasukan kolonial setelah benteng perlawanan jatuh, keteguhan jiwanya tak pernah goyah; beliau menolak bekerja sama hingga akhirnya jatuh sakit dan mengembuskan napas terakhirnya di atas kapal perang Evertzen dalam perjalanan menuju tempat pengasingan di Pulau Jawa pada 2 Januari 1818.'
),

(
    'I Gusti Ngurah Rai',
    'I Gusti Ngurah Rai',
    'Pemimpin Puputan Margarana & Pejuang Bali',
    'assets/images/ngurah_rai.jpg',
    'Badung, Bali',
    '1906 – 1946',
    'I Gusti Ngurah Rai merupakan seorang perwira militer sekaligus pahlawan nasional yang menjadi pimpinan tertinggi perlawanan bersenjata rakyat Bali dalam mempertahankan kedaulatan Republik Indonesia pascaproklamasi kemerdekaan. Sebagai komandan pasukan Ciung Wanara, beliau memimpin konsolidasi kekuatan gerilya untuk menolak tegas bujukan serta intervensi militer Belanda yang hendak mendirikan Negara Indonesia Timur (NIT). Puncak perjuangan gigih beliau terjadi dalam pertempuranPuputan Margarana pada 20 November 1946, di mana beliau bersama seluruh pasukannya memilih bertempur hingga titik darah penghabisan daripada menyerah kepada musuh, hingga akhirnya beliau gugur sebagai pahlawan bangsa di medan laga.'
),

(
    'Otto Iskandardinata',
    'Otto Iskandardinata',
    'Pejuang Pergerakan Nasional & Tokoh Jawa Barat',
    'assets/images/otto_iskandardinata.jpg',
    'Bandung, Jawa Barat',
    '1897 – 1945',
    'Raden Otto Iskandardinata merupakan seorang tokoh pahlawan nasional dan pejuang pergerakan kemerdekaan Indonesia yang memegang peranan strategis sebagai salah satu anggota Badan Penyelidik Usaha-Usaha Persiapan Kemerdekaan Indonesia (BPUPKI) serta PPKI. Beliau dikenal sangat aktif berkiprah dalam panggung politik nasional dan organisasi kepemudaan, baik pada masa kolonial Hindia Belanda maupun pada era Pasca-Proklamasi Kemerdekaan Indonesia. Karena keberanian, ketegasan, dan sifat pantang menyerah yang konsisten beliau tunjukkan dalam menyuarakan aspirasi rakyat serta menentang kebijakan penjajah, beliau mendapatkan julukan kehormatan yang sangat masyhur, yaitu Si Jalak Harupat.'
),

(
    'Kapitan Pattimura',
    'Thomas Matulessy',
    'Pemimpin Perlawanan Rakyat Maluku',
    'assets/images/pattimura.jpg',
    'Saparua, Maluku',
    '1783 – 1817',
    'Kapitan Pattimura, yang memiliki nama asli Thomas Matulessy, merupakan pahlawan nasional yang memimpin pergolakan besar perlawanan rakyat Maluku terhadap kekuasaan kolonial Belanda pada tahun 1817. Beliau dipercaya memegang komando tertinggi pertempuran guna menyatukan para raja dan patih dalam merebut Benteng Duurstede serta melancarkan serangan terhadap armada militer Belanda yang berusaha memonopoli perdagangan rempah-rempah. Meskipun sempat berhasil melumpuhkan kekuatan musuh di wilayah Saparua dan sekitarnya, Pattimura akhirnya tertangkap akibat pengkhianatan dan dijatuhi hukuman mati di tiang gantungan di Ambon pada 16 Desember 1817.'
),

(
    'Jenderal Sudirman',
    'Raden Soedirman',
    'Panglima Besar TNI & Pemimpin Perang Gerilya',
    'assets/images/sudirman.jpg',
    'Purbalingga, Jawa Tengah',
    '1916 – 1950',
    'Jenderal Besar Soedirman merupakan Panglima Besar Tentara Nasional Indonesia pertama yang menjadi simbol keteguhan serta kepemimpinan militer tanah air. Beliau memegang peran vital dalam memimpin jalannya strategi pertahanan untuk mempertahankan proklamasi kemerdekaan Indonesia dari ancaman reokupasi pasukan Belanda, terutama saat terjadinya Agresi Militer Belanda II pada tahun 1948. Meskipun dalam kondisi fisik yang kian memburuk akibat penyakit paru-paru parah yang menggerogotinya, beliau menolak untuk menyerah dan memilih tetap memandu jalannya taktik perang gerilya dengan ditandu masuk-keluar hutan belantara, sebelum akhirnya kembali ke Yogyakarta pada tahun 1949 setelah situasi politik dan militer membaik.'
),

(
    'Sultan Hasanuddin',
    'Sultan Hasanuddin',
    'Sultan Gowa & Pejuang Anti-VOC',
    'assets/images/sultan_hasannudin.jpg',
    'Gowa, Sulawesi Selatan',
    '1631 – 1670',
    'Sultan Hasanuddin merupakan Raja Gowa ke-16 sekaligus pahlawan nasional yang memimpin perlawanan bersenjata gigih menentang ekspansi monopoli perdagangan dan imperialisme maskapai dagang Belanda (VOC) di wilayah Sulawesi Selatan. Beliau mengerahkan seluruh kekuatan militer serta maritim Kerajaan Gowa-Tallo demi mempertahankan integritas wilayah, jalur perdagangan rempah-rempah yang strategis, dan kedaulatan kerajaannya dari campur tangan serta tekanan politik Belanda. Karena keteguhan, keberanian, serta ketangguhannya dalam medan pertempuran yang kerap menyulitkan pasukan musuh, pihak kompeni Belanda sendiri memberikan beliau julukan kehormatan yang sangat legendaris, yaitu De Haantjes van Het Oosten atau Ayam Jantan dari Timur.'
);
