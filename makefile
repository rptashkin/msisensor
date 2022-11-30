CXX=g++
HTSLIB=$(realpath vendor/htslib-1.16)
CPP_ROOT=cpp
CXXFLAGS+=    -O2 -fopenmp
LDFLAGS+=    -L${HTSLIB}
LIBS+=    -lm -lz -lpthread -lhts
INCLUDES+=    -I${HTSLIB}
LD_LIBRARY_PATH+= -L${HTSLIB}
export LD_LIBRARY_PATH=${HTSLIB_ROOT}
export HTSLIB_CONFIGURE_OPTIONS="--enable-plugins,--enable-libcurl"


SOURCE = cmds scan distribution refseq polyscan param utilities homo window bamreader sample chi somatic
OBJS= $(patsubst %,%.o,$(SOURCE))

%.o:%.cpp
	        $(CXX) -L ${HTSLIB} $(CXXFLAGS) $(INCLUDES) -c $< -o $@

all: htsfile msisensor

htsfile:
	        $(MAKE) -C ${HTSLIB}

msisensor: $(OBJS)
	       $(CXX) $^ $(CXXFLAGS) $(LDFLAGS) $(LIBS) -Wl,-rpath=${HTSLIB} -o $@

clean:
	        rm -f *.o msisensor
			$(MAKE) -C ${HTSLIB} clean

